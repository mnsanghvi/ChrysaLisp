%include 'inc/func.ninc'
%include 'class/class_vector.ninc'

def_func class/vector/push_back
	;inputs
	;r0 = vector object
	;r1 = object pointer
	;outputs
	;r0 = vector object
	;r1 = object pointer
	;trashes
	;r2-r3, r5-r8

	def_struct local
		ptr local_object
	def_struct_end

	;save inputs
	vp_sub local_size, r4
	set_src r1
	set_dst [r4 + local_object]
	map_src_to_dst

	;increase capacity ?
	vp_cpy [r0 + vector_length], r1
	vp_inc r1
	vp_cpy r1, [r0 + vector_length]
	vpif r1, >, [r0 + vector_capacity]
		;double the capacity
		vp_add r1, r1
		f_call vector, set_capacity, {r0, r1}
	endif

	;save object
	vp_cpy [r4 + local_object], r1
	vp_cpy [r0 + vector_length], r2
	vp_cpy [r0 + vector_array], r3
	vp_mul ptr_size, r2
	vp_add r2, r3
	vp_cpy r1, [r3 - ptr_size]

	vp_add local_size, r4
	vp_ret

def_func_end
