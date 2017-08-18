note
	description: "Summary description for {WSF_FILE_SYSTEM_HANDLER_WITH_COMPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WSF_FILE_SYSTEM_HANDLER_WITH_COMPRESSION

inherit
	WSF_FILE_SYSTEM_HANDLER
		redefine
			initialize,
			process_transfert
		end

create
	make_with_path,
	make_hidden_with_path,
	make,
	make_hidden

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			initialize_compression
		end

	initialize_compression
			-- Initialize compression support, by default no compression
 			-- Gzip with the following media types
			-- applications/javascript
			-- application/json
			-- application/xml
			-- text/css
			-- text/html
			--
		do
			create conneg.make ("", "", "", "")

				-- compression algorithms
			create {ARRAYED_LIST [STRING]} compression_supported_formats.make (0)
			compression_supported_formats.compare_objects

				-- media types supported by compression.
			create {ARRAYED_LIST [STRING]} compression_enabled_media_types.make (0)
			compression_enabled_media_types.compare_objects
			set_default_compression_enabled_media_types
		end

	conneg : SERVER_CONTENT_NEGOTIATION
			-- content negotiation.

feature -- Execution

	process_transfert (f: FILE; req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			ext: READABLE_STRING_32
			ct: detachable READABLE_STRING_8
--			fres: WSF_FILE_RESPONSE_WITH_COMPRESSION
			dt: DATE_TIME
			h: HTTP_HEADER
			l_file: RAW_FILE
			l_content: detachable STRING
		do
			ext := extension (f.path.name)
			ct := extension_mime_mapping.mime_type (ext)
			if ct = Void then
				ct := {HTTP_MIME_TYPES}.application_force_download
			end

				-- Check the CLIENT request
				-- If the client support compression and one of the algorithms is `deflate_compression_format' we can do compression.
				-- and we need to add the corresponding 'Content-Encoding' with supported compression formats.
			if
				attached compression_encoding_variants (req, ct) as l_compression_variants and then
				attached l_compression_variants.encoding as l_encoding and then
				attached l_compression_variants.vary_header_value as l_vary_header
			then
				create h.make
				create l_file.make_with_path (create {PATH}.make_from_string (f.path.name))
				check
					f_valid: l_file.exists and then l_file.is_access_readable
				end
				h.put_last_modified (file_date (l_file))
				l_file.open_read
				l_file.read_stream (l_file.count)
				l_file.close
				l_content := compressed_string (l_file.last_string, l_encoding)
				h.add_header ("Content-Encoding:" + l_encoding)
				h.add_header ("Vary:" + l_vary_header)
				h.put_content_type (ct)
				h.put_content_length (l_content.count)

			 		-- cache control
				create dt.make_now_utc
				h.put_utc_date (dt)
				if max_age >= 0 then
					h.put_cache_control ("max-age=" +max_age.out)
					if max_age > 0 then
						dt := dt.twin
						dt.second_add (max_age)
					end
					h.put_expires_date (dt)
				end

			 	res.set_status_code ({HTTP_STATUS_CODE}.ok)
			 	res.put_header_text (h.string)
			 	res.put_string (l_content)
			else
				Precursor (f, req, res)
			end
		end

feature -- Compression: constants

	gzip_compression_format: STRING = "gzip"
			-- RFC 1952 (gzip compressed format).	

	deflate_compression_format: STRING = "deflate"
			-- RFC 1951 (deflate compressed format).

	compress_compression_format: STRING = "compress"
			-- RFC 1950 (zlib compressed format).

feature -- Compression

	compression_supported_formats : LIST [STRING]
			-- Server side compression supported formats.
			-- Supported compression agorithms: `gzip_compression_format', `deflate_compression_format', `compress_compression_format'.
			-- identity,  means no compression at all.

	compression_enabled_media_types: LIST [STRING]
			-- List of media types supported by compression.

	set_default_compression_format
			-- gzip default format.
		do
			enable_gzip_compression
		end

	disable_all_compression_formats
			-- Remove all items.
		do
			compression_supported_formats.wipe_out
		end

	enable_gzip_compression
			-- add 'gzip' format to the list of 'compression_supported' formats.
		do
			compression_supported_formats.force (gzip_compression_format)
		ensure
			has_gzip: compression_supported_formats.has (gzip_compression_format)
		end

	disable_gzip_compression
			-- remove 'gzip' format to the list of 'compression_supported' formats.
		do
			compression_supported_formats.prune (gzip_compression_format)
		ensure
			not_gzip: not compression_supported_formats.has (gzip_compression_format)
		end

	enable_deflate_compression
			-- add 'deflate' format to the list of 'compression_supported' formats.
		do
			compression_supported_formats.force (deflate_compression_format)
		ensure
			has_deflate: compression_supported_formats.has (deflate_compression_format)
		end

	disable_deflate_compression
			-- remove 'deflate' format to the list of 'compression_supported' formats.
		do
			compression_supported_formats.prune (deflate_compression_format)
		ensure
			not_deflate: not compression_supported_formats.has (deflate_compression_format)
		end

	enable_compress_compression
			-- add 'compress' format to the list of 'compression_supported' formats
		do
			compression_supported_formats.force (compress_compression_format)
		ensure
			has_compress: compression_supported_formats.has (compress_compression_format)
		end

	disable_compress_compression
			-- remove 'deflate' format to the list of 'compression_supported' formats.
		do
			compression_supported_formats.prune (compress_compression_format)
		ensure
			no_compress: not compression_supported_formats.has (compress_compression_format)
		end

feature -- Compression: media types

	set_default_compression_enabled_media_types
			-- Default media types
			-- applications/javascript
			-- application/json
			-- application/xml
			-- text/css
			-- text/html
			-- text/plain			
		do
			compression_enabled_media_types.force ({HTTP_MIME_TYPES}.application_javascript)
			compression_enabled_media_types.force ({HTTP_MIME_TYPES}.application_json)
			compression_enabled_media_types.force ({HTTP_MIME_TYPES}.application_xml)
			compression_enabled_media_types.force ({HTTP_MIME_TYPES}.text_css)
			compression_enabled_media_types.force ({HTTP_MIME_TYPES}.text_html)
			compression_enabled_media_types.force ({HTTP_MIME_TYPES}.text_plain)
		end

	remove_all_compression_enabled_media_types
			-- Remove all items.
		do
			compression_enabled_media_types.wipe_out
		end

	enable_compression_for_media_type (a_media_type: STRING)
		do
			compression_enabled_media_types.force (a_media_type)
		ensure
			has_media_type: compression_enabled_media_types.has (a_media_type)
		end

feature -- Support Compress

	compression_encoding_variants (req: WSF_REQUEST; ct: STRING): detachable HTTP_ACCEPT_ENCODING_VARIANTS
			-- If the client support compression and the server support one of the algorithms
			-- compress it and update the response header.
		local
			l_compression_supported: LIST [STRING]
			l_compression: STRING
		do
			if
				attached req.http_accept_encoding as l_http_encoding and then
				not compression_supported_formats.is_empty and then
				compression_enabled_media_types.has (ct)
			then
				Result := conneg.encoding_preference (compression_supported_formats, l_http_encoding)
				if not Result.is_acceptable then
					Result := Void
				end
			end
		end

	generated_compressed_output (req: WSF_REQUEST; f:FILE; h: HTTP_HEADER; ct: STRING): detachable STRING
			-- If the client support compression and the server support one of the algorithms
			-- compress it and update the response header.
		local
			l_file: RAW_FILE
			l_compression_variants: HTTP_ACCEPT_ENCODING_VARIANTS
			l_compression_supported: LIST [STRING]
			l_compression: STRING
		do
			if
				not compression_supported_formats.is_empty and then
				compression_enabled_media_types.has (ct) and then
				attached req.http_accept_encoding as l_http_encoding
			then
				l_compression_variants := conneg.encoding_preference (compression_supported_formats, l_http_encoding)
				if
					l_compression_variants.is_acceptable and then
					attached l_compression_variants.encoding as l_encoding and then
					attached l_compression_variants.vary_header_value as l_vary_header
				then
					create l_file.make_with_path (create {PATH}.make_from_string (f.path.name))
					if l_file.exists then
						l_file.open_read
						h.put_last_modified (create {DATE_TIME}.make_from_epoch (l_file.date))
						-- Check the CLIENT request
						-- If the client support compression and one of the algorithms is `deflate_compression_format' we can do compression.
						-- and we need to add the corresponding 'Content-Ecoding' witht the supported algorithm.
						l_file.read_stream (l_file.count)
						Result := compressed_string (l_file.last_string, l_encoding)
						h.add_header ("Content-Encoding:" + l_encoding)
						h.add_header ("Vary:" + l_vary_header)
						l_file.close
					end
				end
			end
		end

feature -- Compress Data

 	compressed_string (a_string: STRING; a_encoding: STRING): STRING
 			-- Compress `a_string' using `deflate_compression_format'
		local
			dc: ZLIB_STRING_COMPRESS
		do
			create Result.make_empty
			create dc.string_stream_with_size (Result, 32_768) -- chunk size 32k
			dc.put_string_with_options (a_string, {ZLIB_CONSTANTS}.Z_default_compression, zlb_strategy (a_encoding), {ZLIB_CONSTANTS}.Z_mem_level_9, {ZLIB_CONSTANTS}.z_default_strategy.to_integer_32)
				-- We use the default compression level
				-- We use the default value for windows bits, the range is 8..15. Higher values use more memory, but produce smaller output.
				-- Memory: Higher values use more memory, but are faster and produce smaller output. The default is 8, we use 9.
		end


	zlb_strategy (a_encoding: STRING): INTEGER
		do
			if a_encoding.is_case_insensitive_equal_general (gzip_compression_format) then
				Result := {ZLIB_CONSTANTS}.z_default_window_bits + 16
			elseif a_encoding.is_case_insensitive_equal_general (deflate_compression_format) then
				Result := -{ZLIB_CONSTANTS}.z_default_window_bits
			else
				check compress: a_encoding.is_case_insensitive_equal_general (compress_compression_format)  end
				Result := {ZLIB_CONSTANTS}.z_default_window_bits
			end
		end

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
