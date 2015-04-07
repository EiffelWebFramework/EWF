note
	description: "Summary description for {FLAG_AUTOCOMPLETION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FLAG_AUTOCOMPLETION

inherit

	WSF_AUTOCOMPLETION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			template := "<img src=%"http://www.famfamfam.com/lab/icons/flags/icons/gif/{{=flag}}.gif%"> {{=value}}";
		end

feature -- Implementation

	autocompletion (input: STRING_32): JSON_ARRAY
			-- Implementation
		local
			list: ITERABLE [TUPLE [short: READABLE_STRING_8; name: READABLE_STRING_32]]
			o: JSON_OBJECT
		do
			list := <<["AF", {STRING_32} "Afghanistan"], ["AX", {STRING_32} "Åland Islands"], ["AL", {STRING_32} "Albania"],
					["DZ", {STRING_32} "Algeria"], ["AS", {STRING_32} "American Samoa"],
					["AD", {STRING_32} "Andorra"], ["AO", {STRING_32} "Angola"], ["AI", {STRING_32} "Anguilla"],
					["AQ", {STRING_32} "Antarctica"], ["AG", {STRING_32} "Antigua and Barbuda"],
					["AR", {STRING_32} "Argentina"], ["AM", {STRING_32} "Armenia"], ["AW", {STRING_32} "Aruba"],
					["AU", {STRING_32} "Australia"], ["AT", {STRING_32} "Austria"], ["AZ", {STRING_32} "Azerbaijan"],
					["BS", {STRING_32} "Bahamas"], ["BH", {STRING_32} "Bahrain"], ["BD", {STRING_32} "Bangladesh"],
					["BB", {STRING_32} "Barbados"], ["BY", {STRING_32} "Belarus"], ["BE", {STRING_32} "Belgium"],
					["BZ", {STRING_32} "Belize"], ["BJ", {STRING_32} "Benin"], ["BM", {STRING_32} "Bermuda"],
					["BT", {STRING_32} "Bhutan"], ["BO", {STRING_32} "Bolivia, Plurinational State of"],
					["BQ", {STRING_32} "Bonaire, Sint Eustatius and Saba"], ["BA", {STRING_32} "Bosnia and Herzegovina"],
					["BW", {STRING_32} "Botswana"], ["BV", {STRING_32} "Bouvet Island"],
					["BR", {STRING_32} "Brazil"], ["IO", {STRING_32} "British Indian Ocean Territory"],
					["BN", {STRING_32} "Brunei Darussalam"], ["BG", {STRING_32} "Bulgaria"],
					["BF", {STRING_32} "Burkina Faso"], ["BI", {STRING_32} "Burundi"], ["KH", {STRING_32} "Cambodia"],
					["CM", {STRING_32} "Cameroon"], ["CA", {STRING_32} "Canada"], ["CV", {STRING_32} "Cape Verde"],
					["KY", {STRING_32} "Cayman Islands"], ["CF", {STRING_32} "Central African Republic"],
					["TD", {STRING_32} "Chad"], ["CL", {STRING_32} "Chile"], ["CN", {STRING_32} "China"],
					["CX", {STRING_32} "Christmas Island"], ["CC", {STRING_32} "Cocos (Keeling) Islands"],
					["CO", {STRING_32} "Colombia"], ["KM", {STRING_32} "Comoros"], ["CG", {STRING_32} "Congo"],
					["CD", {STRING_32} "Congo, the Democratic Republic of the"], ["CK", {STRING_32} "Cook Islands"],
					["CR", {STRING_32} "Costa Rica"], ["CI", {STRING_32} "Côte d'Ivoire"],
					["HR", {STRING_32} "Croatia"], ["CU", {STRING_32} "Cuba"], ["CW", {STRING_32} "Curaçao"],
					["CY", {STRING_32} "Cyprus"], ["CZ", {STRING_32} "Czech Republic"], ["DK", {STRING_32} "Denmark"],
					["DJ", {STRING_32} "Djibouti"], ["DM", {STRING_32} "Dominica"], ["DO", {STRING_32} "Dominican Republic"],
					["EC", {STRING_32} "Ecuador"], ["EG", {STRING_32} "Egypt"], ["SV", {STRING_32} "El Salvador"],
					["GQ", {STRING_32} "Equatorial Guinea"], ["ER", {STRING_32} "Eritrea"], ["EE", {STRING_32} "Estonia"],
					["ET", {STRING_32} "Ethiopia"], ["FK", {STRING_32} "Falkland Islands (Malvinas)"],
					["FO", {STRING_32} "Faroe Islands"], ["FJ", {STRING_32} "Fiji"], ["FI", {STRING_32} "Finland"],
					["FR", {STRING_32} "France"], ["GF", {STRING_32} "French Guiana"],
					["PF", {STRING_32} "French Polynesia"], ["TF", {STRING_32} "French Southern Territories"],
					["GA", {STRING_32} "Gabon"], ["GM", {STRING_32} "Gambia"], ["GE", {STRING_32} "Georgia"],
					["DE", {STRING_32} "Germany"], ["GH", {STRING_32} "Ghana"], ["GI", {STRING_32} "Gibraltar"],
					["GR", {STRING_32} "Greece"], ["GL", {STRING_32} "Greenland"], ["GD", {STRING_32} "Grenada"],
					["GP", {STRING_32} "Guadeloupe"], ["GU", {STRING_32} "Guam"], ["GT", {STRING_32} "Guatemala"],
					["GG", {STRING_32} "Guernsey"], ["GN", {STRING_32} "Guinea"], ["GW", {STRING_32} "Guinea-Bissau"],
					["GY", {STRING_32} "Guyana"], ["HT", {STRING_32} "Haiti"], ["HM", {STRING_32} "Heard Island and McDonald Islands"],
					["VA", {STRING_32} "Holy See (Vatican City State)"],
					["HN", {STRING_32} "Honduras"], ["HK", {STRING_32} "Hong Kong"], ["HU", {STRING_32} "Hungary"],
					["IS", {STRING_32} "Iceland"], ["IN", {STRING_32} "India"], ["ID", {STRING_32} "Indonesia"],
					["IR", {STRING_32} "Iran, Islamic Republic of"], ["IQ", {STRING_32} "Iraq"], ["IE", {STRING_32} "Ireland"],
					["IM", {STRING_32} "Isle of Man"], ["IL", {STRING_32} "Israel"],
					["IT", {STRING_32} "Italy"], ["JM", {STRING_32} "Jamaica"], ["JP", {STRING_32} "Japan"], ["JE", {STRING_32} "Jersey"],
					["JO", {STRING_32} "Jordan"], ["KZ", {STRING_32} "Kazakhstan"],
					["KE", {STRING_32} "Kenya"], ["KI", {STRING_32} "Kiribati"], ["KP", {STRING_32} "Korea, Democratic People's Republic of"],
					["KR", {STRING_32} "Korea, Republic of"],
					["KW", {STRING_32} "Kuwait"], ["KG", {STRING_32} "Kyrgyzstan"], ["LA", {STRING_32} "Lao People's Democratic Republic"],
					["LV", {STRING_32} "Latvia"], ["LB", {STRING_32} "Lebanon"],
					["LS", {STRING_32} "Lesotho"], ["LR", {STRING_32} "Liberia"], ["LY", {STRING_32} "Libya"],
					["LI", {STRING_32} "Liechtenstein"], ["LT", {STRING_32} "Lithuania"], ["LU", {STRING_32} "Luxembourg"],
					["MO", {STRING_32} "Macao"], ["MK", {STRING_32} "Macedonia, the former Yugoslav Republic of"],
					["MG", {STRING_32} "Madagascar"], ["MW", {STRING_32} "Malawi"],
					["MY", {STRING_32} "Malaysia"], ["MV", {STRING_32} "Maldives"], ["ML", {STRING_32} "Mali"],
					["MT", {STRING_32} "Malta"], ["MH", {STRING_32} "Marshall Islands"], ["MQ", {STRING_32} "Martinique"],
					["MR", {STRING_32} "Mauritania"], ["MU", {STRING_32} "Mauritius"], ["YT", {STRING_32} "Mayotte"],
					["MX", {STRING_32} "Mexico"], ["FM", {STRING_32} "Micronesia, Federated States of"],
					["MD", {STRING_32} "Moldova, Republic of"], ["MC", {STRING_32} "Monaco"], ["MN", {STRING_32} "Mongolia"],
					["ME", {STRING_32} "Montenegro"], ["MS", {STRING_32} "Montserrat"],
					["MA", {STRING_32} "Morocco"], ["MZ", {STRING_32} "Mozambique"], ["MM", {STRING_32} "Myanmar"],
					["NA", {STRING_32} "Namibia"], ["NR", {STRING_32} "Nauru"], ["NP", {STRING_32} "Nepal"],
					["NL", {STRING_32} "Netherlands"], ["NC", {STRING_32} "New Caledonia"], ["NZ", {STRING_32} "New Zealand"],
					["NI", {STRING_32} "Nicaragua"], ["NE", {STRING_32} "Niger"],
					["NG", {STRING_32} "Nigeria"], ["NU", {STRING_32} "Niue"], ["NF", {STRING_32} "Norfolk Island"],
					["MP", {STRING_32} "Northern Mariana Islands"], ["NO", {STRING_32} "Norway"],
					["OM", {STRING_32} "Oman"], ["PK", {STRING_32} "Pakistan"], ["PW", {STRING_32} "Palau"],
					["PS", {STRING_32} "Palestinian Territory, Occupied"], ["PA", {STRING_32} "Panama"],
					["PG", {STRING_32} "Papua New Guinea"], ["PY", {STRING_32} "Paraguay"], ["PE", {STRING_32} "Peru"],
					["PH", {STRING_32} "Philippines"], ["PN", {STRING_32} "Pitcairn"],
					["PL", {STRING_32} "Poland"], ["PT", {STRING_32} "Portugal"], ["PR", {STRING_32} "Puerto Rico"],
					["QA", {STRING_32} "Qatar"], ["RE", {STRING_32} "Réunion"], ["RO", {STRING_32} "Romania"],
					["RU", {STRING_32} "Russian Federation"], ["RW", {STRING_32} "Rwanda"], ["BL", {STRING_32} "Saint Barthélemy"],
					["SH", {STRING_32} "Saint Helena, Ascension and Tristan da Cunha"],
					["KN", {STRING_32} "Saint Kitts and Nevis"], ["LC", {STRING_32} "Saint Lucia"], ["MF", {STRING_32} "Saint Martin (French part)"],
					["PM", {STRING_32} "Saint Pierre and Miquelon"],
					["VC", {STRING_32} "Saint Vincent and the Grenadines"], ["WS", {STRING_32} "Samoa"],
					["SM", {STRING_32} "San Marino"], ["ST", {STRING_32} "Sao Tome and Principe"],
					["SA", {STRING_32} "Saudi Arabia"], ["SN", {STRING_32} "Senegal"], ["RS", {STRING_32} "Serbia"],
					["SC", {STRING_32} "Seychelles"], ["SL", {STRING_32} "Sierra Leone"],
					["SG", {STRING_32} "Singapore"], ["SX", {STRING_32} "Sint Maarten (Dutch part)"], ["SK", {STRING_32} "Slovakia"],
					["SI", {STRING_32} "Slovenia"], ["SB", {STRING_32} "Solomon Islands"],
					["SO", {STRING_32} "Somalia"], ["ZA", {STRING_32} "South Africa"], ["GS", {STRING_32} "South Georgia and the South Sandwich Islands"],
					["SS", {STRING_32} "South Sudan"],
					["ES", {STRING_32} "Spain"], ["LK", {STRING_32} "Sri Lanka"], ["SD", {STRING_32} "Sudan"], ["SR", {STRING_32} "Suriname"],
					["SJ", {STRING_32} "Svalbard and Jan Mayen"],
					["SZ", {STRING_32} "Swaziland"], ["SE", {STRING_32} "Sweden"], ["CH", {STRING_32} "Switzerland"],
					["SY", {STRING_32} "Syrian Arab Republic"],
					["TW", {STRING_32} "Taiwan, Province of China"], ["TJ", {STRING_32} "Tajikistan"],
					["TZ", {STRING_32} "Tanzania, United Republic of"], ["TH", {STRING_32} "Thailand"],
					["TL", {STRING_32} "Timor-Leste"], ["TG", {STRING_32} "Togo"], ["TK", {STRING_32} "Tokelau"],
					["TO", {STRING_32} "Tonga"], ["TT", {STRING_32} "Trinidad and Tobago"],
					["TN", {STRING_32} "Tunisia"], ["TR", {STRING_32} "Turkey"], ["TM", {STRING_32} "Turkmenistan"],
					["TC", {STRING_32} "Turks and Caicos Islands"], ["TV", {STRING_32} "Tuvalu"],
					["UG", {STRING_32} "Uganda"], ["UA", {STRING_32} "Ukraine"], ["AE", {STRING_32} "United Arab Emirates"],
					["GB", {STRING_32} "United Kingdom"], ["US", {STRING_32} "United States"],
					["UM", {STRING_32} "United States Minor Outlying Islands"], ["UY", {STRING_32} "Uruguay"],
					["UZ", {STRING_32} "Uzbekistan"], ["VU", {STRING_32} "Vanuatu"],
					["VE", {STRING_32} "Venezuela, Bolivarian Republic of"], ["VN", {STRING_32} "Viet Nam"],
					["VG", {STRING_32} "Virgin Islands, British"],
					["VI", {STRING_32} "Virgin Islands, U.S."], ["WF", {STRING_32} "Wallis and Futuna"],
					["EH", {STRING_32} "Western Sahara"], ["YE", {STRING_32} "Yemen"],
					["ZM", {STRING_32} "Zambia"], ["ZW", {STRING_32} "Zimbabwe"]
				>>

			create Result.make_empty
			across
				list as c
			loop
				if
					attached c.item.short as first and
					attached c.item.name as second
				then
					if second.as_lower.has_substring (input.as_lower) then
						create o.make
						o.put (create {JSON_STRING}.make_from_string (first.as_lower), "flag")
						o.put (create {JSON_STRING}.make_from_string_32 (second), "value")
						Result.add (o)
					end
				end
			end
		end

end
