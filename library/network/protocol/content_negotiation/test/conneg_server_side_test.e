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
			create conneg.make ("application/json", "es", "UTF-8", "")
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
			assert ("Media type is void",media_variants.type = Void)

			-- Scenario 2, the client doesnt send values in the header, Accept:
			media_variants := conneg.media_type_preference (mime_types_supported, "")
			assert ("Expected Acceptable", media_variants.is_acceptable)
			assert ("Variants is dettached",media_variants.supported_variants = Void)
			assert ("Mime is defaul", conneg.mime_default.is_equal (media_variants.type))
			assert ("Variant header", media_variants.variant_header = Void)

			--Scenario 3, the server select the best match, and set the vary header
			media_variants := conneg.media_type_preference (mime_types_supported, "text/*,application/json;q=0.5")
			assert ("Expected Acceptable", media_variants.is_acceptable)
			assert ("Variants is dettached",media_variants.supported_variants = Void)
			assert ("Variant Header", media_variants.variant_header.is_equal ("Accept"))
			assert ("Media Type is application/json", media_variants.type.is_equal ("application/json"))

		end



	test_charset_negotiation
		local
			charset_variants : CHARACTER_ENCODING_VARIANT_RESULTS
			charset_supported : LIST [STRING]
			l_charset : STRING
		do
			-- Scenario 1, the server side does not support client preferences
			l_charset := "UTF-8, iso-8859-5"
			charset_supported := l_charset.split(',')
			charset_variants := conneg.charset_preference (charset_supported, "unicode-1-1")
			assert ("Expected Not Acceptable", not charset_variants.is_acceptable)
			assert ("Same Value at 1",charset_supported.at (1).is_equal (charset_variants.supported_variants.at (1)))
			assert ("Same count",charset_supported.count = charset_variants.supported_variants.count)
			assert ("Variant header is void",charset_variants.variant_header = Void)
			assert ("Character type is void",charset_variants.type = Void)


			-- Scenario 2, the client doesnt send values in the header, Accept-Charset:
			charset_variants := conneg.charset_preference (charset_supported, "")
			assert ("Expected Acceptable", charset_variants.is_acceptable)
			assert ("Variants is dettached",charset_variants.supported_variants = Void)
			assert ("Charset is defaul", conneg.charset_default.is_equal (charset_variants.type))
			assert ("Variant header", charset_variants.variant_header = Void)


			--Scenario 3, the server select the best match, and set the vary header
			charset_variants := conneg.charset_preference (charset_supported, "unicode-1-1, UTF-8;q=0.3, iso-8859-5")
			assert ("Expected Acceptable", charset_variants.is_acceptable)
			assert ("Variants is dettached",charset_variants.supported_variants = Void)
			assert ("Variant Header", charset_variants.variant_header.is_equal ("Accept-Charset"))
			assert ("Character Type is iso-8859-5", charset_variants.type.is_equal ("iso-8859-5"))
		end

	test_compression_negotiation
		local
			compression_variants : COMPRESSION_VARIANT_RESULTS
			compression_supported : LIST [STRING]
			l_compression : STRING
		do
			-- Scenario 1, the server side does not support client preferences
			l_compression := ""
			compression_supported := l_compression.split(',')
			compression_variants := conneg.encoding_preference (compression_supported, "gzip")
			assert ("Expected Not Acceptable", not compression_variants.is_acceptable)
			assert ("Same Value at 1",compression_supported.at (1).is_equal (compression_variants.supported_variants.at (1)))
			assert ("Same count",compression_supported.count = compression_variants.supported_variants.count)
			assert ("Variant header is void",compression_variants.variant_header = Void)
			assert ("Compression type is void",compression_variants.type = Void)


			-- Scenario 2, the client doesnt send values in the header, Accept-Encoding
			compression_variants := conneg.encoding_preference (compression_supported, "")
			assert ("Expected Acceptable", compression_variants.is_acceptable)
			assert ("Variants is dettached",compression_variants.supported_variants = Void)
			assert ("Compression is defaul", conneg.encoding_default.is_equal (compression_variants.type))
			assert ("Variant header", compression_variants.variant_header = Void)


			--Scenario 3, the server select the best match, and set the vary header
			l_compression := "gzip"
			compression_supported := l_compression.split(',')
			conneg.set_encoding_default("gzip")
			compression_variants := conneg.encoding_preference (compression_supported, "compress,gzip;q=0.7")
			assert ("Expected Acceptable", compression_variants.is_acceptable)
			assert ("Variants is dettached",compression_variants.supported_variants = Void)
			assert ("Variant Header", compression_variants.variant_header.is_equal ("Accept-Encoding"))
			assert ("Encoding Type is gzip", compression_variants.type.is_equal ("gzip"))


			-- Scenario 4, the server set `identity' and the client doesn't mention identity
			l_compression := "identity"
			compression_supported := l_compression.split(',')
			conneg.set_encoding_default("gzip")
			compression_variants := conneg.encoding_preference (compression_supported, "gzip;q=0.7")
			assert ("Expected Acceptable", compression_variants.is_acceptable)
			assert ("Variants is dettached",compression_variants.supported_variants = Void)
			assert ("Variant Header", compression_variants.variant_header.is_equal ("Accept-Encoding"))
			assert ("Encoding Type is identity", compression_variants.type.is_equal ("identity"))

			-- Scenario 5, the server set `identity' and the client mention identity,q=0
			l_compression := "identity"
			compression_supported := l_compression.split(',')
			conneg.set_encoding_default("gzip")
			compression_variants := conneg.encoding_preference (compression_supported, "identity;q=0")
			assert ("Expected Not Acceptable", not compression_variants.is_acceptable)
			assert ("Variants is attached",attached compression_variants.supported_variants )
			assert ("Variant Header is void", compression_variants.variant_header = Void)
			assert ("Encoding Type is Void", compression_variants.type = Void)

			-- Scenario 6, the server set `identity' and the client mention *,q=0
			l_compression := "identity"
			compression_supported := l_compression.split(',')
			conneg.set_encoding_default("gzip")
			compression_variants := conneg.encoding_preference (compression_supported, "*;q=0")
			assert ("Expected Not Acceptable", not compression_variants.is_acceptable)
			assert ("Variants is attached",attached compression_variants.supported_variants )
			assert ("Variant Header is void", compression_variants.variant_header = Void)
			assert ("Encoding Type is Void", compression_variants.type = Void)


			-- Scenario 7, the server set `identity' and the client mention identity;q=0.5, gzip;q=0.7,compress
			l_compression := "identity"
			compression_supported := l_compression.split(',')
			conneg.set_encoding_default("gzip")
			compression_variants := conneg.encoding_preference (compression_supported, "identity;q=0.5, gzip;q=0.7,compress")
			assert ("Expected Acceptable",compression_variants.is_acceptable)
			assert ("Variants is void",compression_variants.supported_variants = Void)
			assert ("Variant Header", compression_variants.variant_header.is_equal ("Accept-Encoding"))
			assert ("Encoding Type is identity", compression_variants.type.is_equal ("identity"))


			-- Scenario 8, the server set `identity' and the client mention identity;q=0.5
			l_compression := "identity"
			compression_supported := l_compression.split(',')
			conneg.set_encoding_default("gzip")
			compression_variants := conneg.encoding_preference (compression_supported, "identity;q=0.5")
			assert ("Expected Acceptable",compression_variants.is_acceptable)
			assert ("Variants is void",compression_variants.supported_variants = Void)
			assert ("Variant Header", compression_variants.variant_header.is_equal ("Accept-Encoding"))
			assert ("Encoding Type is identity", compression_variants.type.is_equal ("identity"))


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
			assert ("Language type is void",language_variants.type = Void)


			-- Scenario 2, the client doesnt send values in the header, Accept-Language:
			language_variants := conneg.language_preference (languages_supported, "")
			assert ("Expected Acceptable", language_variants.is_acceptable)
			assert ("Variants is dettached",language_variants.supported_variants = Void)
			assert ("Language is defaul", conneg.language_default.is_equal (language_variants.type))
			assert ("Variant header", language_variants.variant_header = Void)


			--Scenario 3, the server select the best match, and set the vary header
			language_variants := conneg.language_preference (languages_supported, "fr,es;q=0.4")
			assert ("Expected Acceptable", language_variants.is_acceptable)
			assert ("Variants is dettached",language_variants.supported_variants = Void)
			assert ("Variant Header", language_variants.variant_header.is_equal ("Accept-Language"))
			assert ("Language Type is fr", language_variants.type.is_equal ("fr"))


		end

feature -- Implementation
	conneg : CONNEG_SERVER_SIDE
end
