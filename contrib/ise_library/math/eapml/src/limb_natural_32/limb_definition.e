note
	description: "Summary description for {LIMB_DEFINITION}."
	author: ""
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"

deferred class
	LIMB_DEFINITION

feature

	limb_high_bit: INTEGER = 31
			-- Index of the high bit of a limb

	limb_bits: INTEGER = 32
			-- Number of bits in a limb
end
