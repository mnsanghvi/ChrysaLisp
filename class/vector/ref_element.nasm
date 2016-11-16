%include 'inc/func.ninc'
%include 'class/class_vector.ninc'

def_func class/vector/ref_element
	;inputs
	;r0 = vector object
	;r1 = vector element
	;outputs
	;r0 = vector object
	;r1 = object

	vp_push r0
	vp_cpy [r0 + vector_array], r0
	vp_mul ptr_size, r1
	vp_add r1, r0
	f_call ref, ref, {[r0]}
	vp_cpy r0, r1
	vp_pop r0
	vp_ret

def_func_end
