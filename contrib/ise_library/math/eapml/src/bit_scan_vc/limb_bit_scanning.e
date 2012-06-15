note
	description: "Summary description for {LIMB_BIT_SCANNING}."
	author: ""
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"

deferred class
	LIMB_BIT_SCANNING

inherit
	LIMB_DEFINITION

feature

	leading_zeros (limb_a: NATURAL_32): INTEGER
		do
			if limb_a = 0 then
				Result := limb_bits
			else
				Result := limb_high_bit - most_significant_one (limb_a)
			end
		end

	most_significant_one (limb_a: NATURAL_32): INTEGER
			-- 31 high, 0 low
		require
			limb_a /= 0
		do
			bit_scan_reverse ($Result, limb_a)
		end

	trailing_zeros (limb_a: NATURAL_32): INTEGER
			-- 31 high, 0 low
		require
			limb_a /= 0
		do
			bit_scan_forward ($Result, limb_a)
		end

feature {NONE} -- Implementation

	bit_scan_reverse (target: POINTER; limb_a: NATURAL_32)
		external
			"C inline use %"intrin.h%""
		alias
			"[
				_BitScanReverse ($target, $limb_a);
			]"
		end

	bit_scan_forward (target: POINTER; limb_a: NATURAL_32)
		external
			"C inline use %"intrin.h%""
		alias
			"[
				_BitScanForward ($target, $limb_a);
			]"
		end
end
