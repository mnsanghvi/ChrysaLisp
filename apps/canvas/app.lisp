;math tools
(run 'apps/canvas/math.lisp)

(defq canvas_scale (pop argv) canvas_height (pop argv) canvas_width (pop argv) canvas (pop argv)
	pen-col 0 brush-col 0
	mitre-join 0 bevel-join 1 round-join 2
	butt-cap 0 square-cap 1 tri-cap 2 arrow-cap 3 round-cap 4)

(defun set-pen-col (_) (setq pen-col _))
(defun set-brush-col (_) (setq brush-col _))

(defun fbox (x y w h)
	(defq h (add y h) y (dec y))
	(while (lt (setq y (inc y)) h)
		(pixel canvas brush-col x y w)))

(defun fpoly (_)
	(defq e (list) ys max-long ye min-long)
	(each (lambda (_)
		(setq _ (map (lambda (_) (vec-scale-2d _ canvas_scale)) _))
		(reduce (lambda (p1 p2)
			(defq x1 (add (elem 0 p1) 0.5) y1 (bit-asr (add (elem 1 p1) 0.5) fp-shift)
				x2 (add (elem 0 p2) 0.5) y2 (bit-asr (add (elem 1 p2) 0.5) fp-shift))
			(cond
				((lt y1 y2)
					(setq ys (min ys y1) ye (max ye y2))
					(push e (list x1 y1 y2 (div (sub x2 x1) (sub y2 y1)))))
				((gt y1 y2)
					(setq ys (min ys y2) ye (max ye y1))
					(push e (list x2 y2 y1 (div (sub x1 x2) (sub y1 y2))))))
			p2) _ (elem -2 _))) _)
	(sort (lambda (e1 e2)
		(lt (elem 1 e1) (elem 1 e2))) e)
	(defq i 0 j 0 ys (dec ys))
	(while (ne (setq ys (inc ys)) ye)
		(each! i j nil (lambda (_)
			(if (eq ys (elem 2 _)) (elem-set 0 _ min-long))) (list e))
		(while (and (ne j (length e)) (eq ys (elem 1 (elem j e))))
			(setq j (inc j)))
		(sort (lambda (e1 e2)
			(lt (elem 0 e1) (elem 0 e2))) e i j)
		(while (and (ne i (length e)) (eq (elem 0 (elem i e)) min-long))
			(setq i (inc i)))
		(defq k (sub i 2))
		(while (ne (setq k (add k 2)) j)
			(defq e1 (elem k e) e2 (elem (inc k) e)
				x1 (elem 0 e1) x2 (elem 0 e2))
			(elem-set 0 e1 (add x1 (elem 3 e1)))
			(elem-set 0 e2 (add x2 (elem 3 e2)))
			(setq x1 (bit-asr x1 fp-shift) x2 (bit-asr x2 fp-shift))
			(pixel canvas brush-col x1 ys (sub x2 x1)))))

(set-brush-col 0xff0000ff)
(fpoly (list (list
	(list 0 0)
	(list (fmul canvas_width 0.25) canvas_height)
	(list (fmul canvas_width 0.5) 0)
	(list (add (fmul canvas_width 0.5) (fmul canvas_width 0.25)) canvas_height)
	(list canvas_width 0)
	(list (fmul canvas_width 0x0.1) canvas_height))))

(set-brush-col 0xff00ff00)
(fpoly
	(stroke-polyline-2d
		(list)
		(fmul canvas_width 0x0.1)
		round-join
		round-cap
		round-cap
		(list (list
			(list (fmul canvas_width 0o0.1) (fmul canvas_height 0o0.1))
			(list (sub canvas_width (fmul canvas_width 0.25)) (fmul canvas_height 0.166))
			(list (sub canvas_width (fmul canvas_width 0o0.1)) (sub canvas_height (fmul canvas_height 0o0.1)))))))

(set-brush-col 0xff00ffff)
(fpoly
	(stroke-polygon-2d
		(list)
		(fmul canvas_width 0.01)
		mitre-join
		(stroke-polyline-2d
			(list)
			(fmul canvas_width 0.033)
			bevel-join
			round-cap
			arrow-cap
			(list (gen-bezier-polyline-2d
				(list)
				(list (fmul canvas_width 0x0.1) (sub canvas_height (fmul canvas_height 0x0.1)))
				(list (fmul canvas_width 0o0.1) (fmul canvas_height 0x0.1))
				(list (fmul canvas_width 0.25) (fmul canvas_height 0.33))
				(list (sub canvas_width (fmul canvas_width 0.1)) (fmul canvas_height 0.1)))))))

(set-brush-col 0xffff0000)
(fpoly
	(stroke-polygon-2d
		(list)
		(fmul canvas_width 0.025)
		mitre-join
		(stroke-polyline-2d
			(list)
			(fmul canvas_width 0.05)
			bevel-join
			square-cap
			tri-cap
			(list
				(gen-arc-polyline-2d
					(list)
					(list (add (fmul canvas_width 0.33) (fmul canvas_width 0x0.1))
						(add (fmul canvas_height 0.5) (fmul canvas_height 0o0.1)))
					(fmul canvas_width 0.25)
					1.0
					1.0)
				(gen-arc-polyline-2d
					(list)
					(list (add (fmul canvas_width 0.33) (fmul canvas_width 0x0.1))
						(add (fmul canvas_height 0.5) (fmul canvas_height 0o0.1)))
					(fmul canvas_width 0o0.1)
					4.0
					2.0)))))

(pixel canvas)