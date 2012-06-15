note
	description: "A block cipher that can be the target of CFB mode"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-11 18:13:16 +0100 (ven., 11 nov. 2011) $"
	revision: "$Revision: 87787 $"
	quote: "The ultimate result of shielding men from the effects of folly is to fill the world with fools. - Herbert Spencer (1891)"

deferred class
	CFB_TARGET

feature
	block_size: INTEGER_32
		deferred
		ensure
			Result > 0
		end

	cfb_ready: BOOLEAN
		deferred
		end

	encrypt_block (in: SPECIAL [NATURAL_8] in_offset: INTEGER_32 out_array: SPECIAL [NATURAL_8] out_offset: INTEGER_32)
		require
			cfb_ready
			in.valid_index (in_offset)
			in.valid_index (in_offset + block_size - 1)
			out_array.valid_index (out_offset)
			out_array.valid_index (out_offset + block_size - 1)
		deferred
		end
end
