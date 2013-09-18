note
	description: "Summary description for {CONTACT_AUTOCOMPLETION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONTACT_AUTOCOMPLETION

inherit

	WSF_AUTOCOMPLETION

create
	make

feature {NONE} -- Initialization

	make ()
		do
			template := "<div class=%"clearfix%" style=%"min-width:250px%"><img src=%"http://api.randomuser.me/0.2/portraits/{{=img}}.jpg%" style=%"max-width:50px;margin-right:10px%" class=%"img-circle pull-left%"> <b>{{=value}}</b><br /><small>{{=company}}</small></div>";
			list := <<["Zelma Hays","Applideck","women/13"],["Little Dixon","Centregy","men/20"],["Marta Fuentes","Papricut","women/11"],["Aileen Dillon","Neteria","women/9"],["Noel Melendez","Corporana","men/19"],["Gutierrez Francis","Capscreen","men/3"],["Valerie Weiss","Zizzle","women/9"],["Mabel Hammond","Pyramax","women/19"],["Mckay Logan","Providco","men/17"],["Hazel Colon","Translink","women/14"],["Margery Whitney","Tropoli","women/21"],["Saundra Neal","Geekmosis","women/20"],["Meghan Pittman","Micronaut","women/16"],["Adrienne Woodward","Mixers","women/8"],["Harriett Macdonald","Anarco","women/4"],["Velasquez Curtis","Zensus","men/4"],["Victoria Greene","Zorromop","women/10"],["Hood Barron","Kangle","men/2"],["Mccullough Cross","Kindaloo","men/15"],["Porter Hart","Kongle","men/15"],["Fox Bryant","Columella","men/17"],["Singleton Knapp","Marketoid","men/10"],["Gracie Lane","Solgan","women/15"],["Randall Cobb","Barkarama","men/7"],["Miranda Brooks","Earwax","men/1"],["Teresa Taylor","Stockpost","women/6"]>>

		end

feature -- Implementation

	autocompletion (input: STRING): JSON_ARRAY
		local
			o: JSON_OBJECT
		do
			create Result.make_array
			across
				list as c
			loop
				if attached {STRING} c.item.item (1) as value and attached {STRING} c.item.item (3) as img and attached {STRING} c.item.item (2) as company then
					if value.as_lower.has_substring (input.as_lower) then
						create o.make
						o.put (create {JSON_STRING}.make_json (img), "img")
						o.put (create {JSON_STRING}.make_json (value), "value")
						o.put (create {JSON_STRING}.make_json (company), "company")
						Result.add (o)
					end
				end
			end
		end

	list: ITERABLE [TUPLE [STRING, STRING]]

end
