note
	description: "Summary description for {FITNESS_AND_QUALITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FITNESS_AND_QUALITY

inherit
	COMPARABLE

	DEBUG_OUTPUT
		undefine
			is_equal
		end

create
	make

feature -- Initialization

	make (a_fitness: INTEGER; a_quality: REAL_64)
		do
			fitness := a_fitness
			quality := a_quality
			create mime_type.make_empty
		ensure
			fitness_assigned : fitness = a_fitness
			quality_assigned : quality = a_quality
		end

feature -- Access

	fitness: INTEGER

	quality: REAL_64

	mime_type: STRING
			-- optionally used
			-- empty by default


feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make_from_string (mime_type)
			Result.append (" (")
			Result.append ("quality=" + quality.out)
			Result.append (" ; fitness=" + fitness.out)
			Result.append (" )")
		end

feature -- Element Change

	set_mime_type (a_mime_type: STRING)
			-- set mime_type with `a_mime_type'	
		do
			mime_type := a_mime_type
		ensure
			mime_type_assigned : mime_type.same_string (a_mime_type)
		end

feature -- Comparision

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if fitness = other.fitness then
				Result := quality < other.quality
			else
			   Result := fitness < other.fitness
			end
		end
note
	copyright: "2011-2011, Javier Velilla, Jocelyn Fiat and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end

