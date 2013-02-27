note
	description: "Summary description for {OPENID_CONSUMER_VALIDATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OPENID_CONSUMER_VALIDATION

create
	make_from_uri,
	make_from_string

feature {NONE} -- Initialization

	make_from_uri (o: OPENID_CONSUMER; a_uri: URI)
		do
			openid := o
			uri := a_uri
			return_url := o.return_url
			create attributes.make (0)
		end

	make_from_string (o: OPENID_CONSUMER; a_uri: READABLE_STRING_8)
		do
			make_from_uri (o, create {URI}.make_from_string (a_uri))
		end

	uri: URI

	return_url: READABLE_STRING_8

feature -- Access		

	openid: OPENID_CONSUMER

	identity: detachable READABLE_STRING_8

	attributes: STRING_TABLE [READABLE_STRING_32]

feature -- Basic operation

	validate
			-- Is openid identifier validated?
		local
			l_claimed_id: detachable READABLE_STRING_8
			tb: STRING_TABLE [detachable READABLE_STRING_32]
			cl: LIBCURL_HTTP_CLIENT
			ctx: detachable HTTP_CLIENT_REQUEST_CONTEXT
			ret: URI
			sess: HTTP_CLIENT_SESSION
		do
			is_valid := False
			create ret.make_from_string (return_url)
			create tb.make (5)
			if attached uri.decoded_query_items as q_lst then
				if attached item_by_name ("openid.claimed_id", q_lst) as q_claimed_id then
					l_claimed_id := q_claimed_id.as_string_8
				elseif attached item_by_name ("openid.identity", q_lst) as l_id then
					l_claimed_id := l_id
				end
				identity := l_claimed_id
				tb.force (item_by_name ("openid.assoc_handle", q_lst), "openid.assoc_handle")
				tb.force (item_by_name ("openid.signed", q_lst), "openid.signed")
				tb.force (item_by_name ("openid.sig", q_lst), "openid.sig")
				if attached item_by_name ("openid.ns", q_lst) as q_ns then
						-- We're dealing with an OpenID 2.0 server, so let's set an ns
						-- Even though we should know location of the endpoint,
						-- we still need to verify it by discovery, so $server is not set here
					tb.force ("http://specs.openid.net/auth/2.0", "openid.ns")
				elseif
					attached item_by_name ("openid.claimed_id", q_lst) as q_claimed_id
					and then (not attached item_by_name ("openid.identity", q_lst) as l_identity
						or else not q_claimed_id.same_string (l_identity))
				then
					-- If it's an OpenID 1 provider, and we've got claimed_id,
					-- we have to append it to the returnUrl, like authUrl_v1 does.
					ret.add_query_parameter ("openid.claimed_id", q_claimed_id)
					return_url := ret.string
				else
				end

				if
					attached item_by_name ("openid.return_to", q_lst) as q_return_to and then
					not return_url.same_string (q_return_to)
				then
					-- The return_to url must match the url of current request.
					-- I'm assuing that noone will set the returnUrl to something that doesn't make sense.

					-- False, FIXME, exception ...					
				end
				if l_claimed_id /= Void then
					if
						attached openid.discovering_info (l_claimed_id) as d_info and then
						not openid.has_error and then not d_info.has_error
					then
						if attached item_by_name ("openid.signed", q_lst) as lst_signed then
							across
								lst_signed.split (',') as c
							loop
								tb.force (item_by_name ("openid." + c.item, q_lst), "openid." + c.item)
							end
						end

						tb.force ("check_authentication", "openid.mode")
						create cl.make
						create ctx.make
						across
							tb as c
						loop
							if attached c.item as l_value then
								ctx.add_form_parameter (c.key.to_string_32, l_value)
							end
						end
						sess := cl.new_session (d_info.server_uri)
						sess.set_is_insecure (True)
						if attached sess.post ("", ctx, Void) as res then
							if res.error_occurred then
							elseif attached {STRING} res.body as l_body then
								is_valid := l_body.substring_index ("is_valid:true", 1) > 0
								if is_valid then
									get_attributes (q_lst)
								end
							end
						end
					end
				end
			end
		end

	get_attributes (lst: LIST [TUPLE [name: READABLE_STRING_32; value: detachable READABLE_STRING_32]])
		local
			s: READABLE_STRING_32
			sreg_keys: ARRAYED_LIST [READABLE_STRING_32]
		do
			attributes.wipe_out

			get_sreg_attributes (lst)
			get_ax_attributes (lst)
		end

	get_sreg_attributes (lst: LIST [TUPLE [name: READABLE_STRING_32; value: detachable READABLE_STRING_32]])
		local
			s: READABLE_STRING_32
			sreg_keys: ARRAYED_LIST [READABLE_STRING_32]
		do
			if attached item_by_name ("openid.signed", lst) as l_signed then
					-- sreg attributes
				create sreg_keys.make (3)
				across
					l_signed.split (',') as c
				loop
					s := c.item
					if s.starts_with ("sreg.") then
						sreg_keys.force ("openid." + s)
					end
				end
				across
					sreg_keys as c
				loop
					s := c.item
					if attached item_by_name (s, lst) as v then
						attributes.force (v, s.substring (5, s.count))
					end
				end
			end
		end

	get_ax_attributes (lst: LIST [TUPLE [name: READABLE_STRING_32; value: detachable READABLE_STRING_32]])
		local
			s: READABLE_STRING_32
			ax_keys: ARRAYED_LIST [READABLE_STRING_32]
			l_alias: detachable READABLE_STRING_8
			k_value, k_type, k_count, k: STRING
			i: INTEGER
		do
			if attached item_by_name ("openid.signed", lst) as l_signed then
					-- ax attributes
				across
					l_signed.split (',') as c
				loop
					s := c.item
					if s.starts_with ("ns.") then
						if attached item_by_name (s, lst) as v then
							if s.same_string ("ns.ax") and v.same_string ("http://openid.net/srv/ax/1.0") then
								l_alias := "ax."
							else
								if v.same_string ("http://openid.net/srv/ax/1.0") then
									l_alias := s.substring (("ns.").count, s.count) + "."
								end
							end
						end
					end
				end
				if l_alias /= Void then
					create ax_keys.make (lst.count)
					across
						l_signed.split (',') as c
					loop
						s := c.item
						if s.starts_with (l_alias) then
							ax_keys.force ("openid." + s)
						end
					end

					k_value := "openid." + l_alias + "value."
					k_type := "openid." + l_alias + "type."
					k_count := "openid." + l_alias + "count."
					across
						ax_keys as c
					loop
						s := c.item
						if attached item_by_name (s, lst) as v then
							if s.starts_with (k_value) then
								k := s.substring (k_value.count + 1, s.count)
								i := k.index_of ('.', 1)
								if i > 1 then
									k.keep_head (i - 1)
								end
								if attached item_by_name (k_type + k, lst) as l_type then
									if l_type.starts_with ("http://axschema.org/") then
										check ("http://axschema.org/").count = 20 end
										attributes.force (v, l_type.substring (21, l_type.count))
									elseif l_type.starts_with ("http://schema.openid.net/") then
										check ("http://schema.openid.net/").count = 25 end
										attributes.force (v, l_type.substring (26, l_type.count))
									else
										-- unsupported schema domain.
									end
								else
									-- no alias !!!								
								end
							end
							attributes.force (v, s.substring (5, s.count))
						end
					end
				end
			end
		end

	item_by_name (a_name: READABLE_STRING_32; lst: like {URI}.decoded_query_items): detachable READABLE_STRING_32
		local
			l_found: BOOLEAN
		do
			if lst /= Void then
				across
					lst as c
				until
					l_found
				loop
					if a_name.same_string (c.item.name) then
						Result := c.item.value
						l_found := True
					end
				end
			end
		end

feature -- Access

	is_valid: BOOLEAN



end
