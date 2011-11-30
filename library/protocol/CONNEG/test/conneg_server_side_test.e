note
	description: "Summary description for {CONNEG_SERVER_SIDE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONNEG_SERVER_SIDE_TEST
inherit
	EQA_TEST_SET
	redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
			-- Called after all initializations in `default_create'.
		do
			create conneg.make ("application/json", "es", "UTF8", "")
			-- set default values
		end

feature -- Test routines
	test_media_type_negotiation
		local
			media_variants : MEDIA_TYPE_VARIANT_RESULTS
			mime_types_supported : LIST [STRING]
			l_types : STRING
		do
			-- Scenario 1, the server side does not support client preferences
			l_types := "application/json,application/xbel+xml,application/xml"
			mime_types_supported := l_types.split(',')
			media_variants := conneg.media_type_preference (mime_types_supported, "text/html")
			assert ("Expected Not Acceptable", not media_variants.is_acceptable)
			assert ("Same Value at 1",mime_types_supported.at (1).is_equal (media_variants.supported_variants.at (1)))
			assert ("Same count",mime_types_supported.count = media_variants.supported_variants.count)
			assert ("Variant header is void",media_variants.variant_header = Void)
			assert ("Media type is void",media_variants.media_type = Void)

			-- Scenario 2, the client doesnt send values in the header, Accept:
			media_variants := conneg.media_type_preference (mime_types_supported, "")
			assert ("Expected Acceptable", media_variants.is_acceptable)
			assert ("Variants is dettached",media_variants.supported_variants = Void)
			assert ("Mime is defaul", conneg.mime_default.is_equal (media_variants.media_type))
			assert ("Variant header", media_variants.variant_header = Void)

			--Scenario 3, the server select the best match, and set the vary header
			media_variants := conneg.media_type_preference (mime_types_supported, "text/*,application/json;q=0.5")
			assert ("Expected Acceptable", media_variants.is_acceptable)
			assert ("Variants is dettached",media_variants.supported_variants = Void)
			assert ("Variant Header", media_variants.variant_header.is_equal ("Accept"))
			assert ("Media Type is application/json", media_variants.media_type.is_equal ("application/json"))

		end



	test_language_negotiation
		local
			language_variants : LANGUAGE_VARIANT_RESULTS
			languages_supported : LIST [STRING]
			l_languages : STRING
		do
			-- Scenario 1, the server side does not support client preferences
			l_languages := "es,en,en-US,fr;q=0.6"
			languages_supported := l_languages.split(',')
			language_variants := conneg.language_preference (languages_supported, "de")
			assert ("Expected Not Acceptable", not language_variants.is_acceptable)
			assert ("Same Value at 1",languages_supported.at (1).is_equal (language_variants.supported_variants.at (1)))
			assert ("Same count",languages_supported.count = language_variants.supported_variants.count)
			assert ("Variant header is void",language_variants.variant_header = Void)
			assert ("Language type is void",language_variants.language_type = Void)


			-- Scenario 2, the client doesnt send values in the header, Accept-Language:
			language_variants := conneg.language_preference (languages_supported, "")
			assert ("Expected Acceptable", language_variants.is_acceptable)
			assert ("Variants is dettached",language_variants.supported_variants = Void)
			assert ("Language is defaul", conneg.language_default.is_equal (language_variants.language_type))
			assert ("Variant header", language_variants.variant_header = Void)


			--Scenario 3, the server select the best match, and set the vary header
			language_variants := conneg.language_preference (languages_supported, "fr,es;q=0.4")
			assert ("Expected Acceptable", language_variants.is_acceptable)
			assert ("Variants is dettached",language_variants.supported_variants = Void)
			assert ("Variant Header", language_variants.variant_header.is_equal ("Accept-Language"))
			assert ("Language Type is fr", language_variants.language_type.is_equal ("fr"))


		end
feature -- Implementation
	conneg : CONNEG_SERVER_SIDE
end
