%include 'inc/func.inc'
%include 'class/class_vector.inc'
%include 'class/class_stream_str.inc'
%include 'class/class_boxed_long.inc'
%include 'class/class_error.inc'
%include 'class/class_lisp.inc'

def_func class/lisp/func_readchar
	;inputs
	;r0 = lisp object
	;r1 = args
	;outputs
	;r0 = lisp object
	;r1 = value

	ptr this, args, value
	long length

	push_scope
	retire {r0, r1}, {this, args}

	devirt_call vector, get_length, {args}, {length}
	if {length == 1}
		func_call vector, get_element, {args, 0}, {value}
		if {value->obj_vtable == @class/class_stream_str}
			func_call stream_str, read_char, {value}, {length}
			if {length == -1}
				assign {this->lisp_sym_nil}, {value}
				func_call ref, ref, {value}
			else
				func_call boxed_long, create, {}, {value}
				func_call boxed_long, set_value, {value, length}
			endif
		else
			func_call error, create, {"(read-char stream) not a stream", args}, {value}
		endif
	else
		func_call error, create, {"(read-char stream) wrong number of args", args}, {value}
	endif

	eval {this, value}, {r0, r1}
	pop_scope
	return

def_func_end