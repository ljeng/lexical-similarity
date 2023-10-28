(require 'cl-lib)
(require 'dash)

(defun kahn (graph n)
  (let ((inverse (make-hash-table :test 'eql))
        (stack (cl-loop for v from 0 to (- n 1)
                       if (not (gethash v inverse))
                       collect v))
        order)
    (cl-loop while stack do
             (let* ((u (pop stack))
                    (neighbors (gethash u graph)))
               (push u order)
               (cl-loop for v in neighbors do
                        (setf (gethash v graph) (remove u (gethash v graph) :test 'eql)
                              (gethash u inverse) (remove v (gethash u inverse) :test 'eql))
                        (unless (gethash v inverse)
                          (push v stack))))
             (if (/= (length order) n)
                 (return "Cyclic graph")))
    order))

(defun read-input (file)
  (with-temp-buffer
    (insert-file-contents file)
    (let* ((t (string-to-number (buffer-substring (point-min) (line-end-position))))
           (cases (buffer-substring (1+ (line-end-position)) (point-max)))
           (lines (split-string cases "\n" t)))
      (cons t (mapcar 'string-to-number (butlast lines 1))))))

(defun main ()
  (let* ((input-file "input.txt")
         (output-file "output.txt")
         (input-data (read-input input-file))
         (t (car input-data))
         (cases (cdr input-data)))
    (with-temp-buffer
      (cl-loop for n in cases do
               (let* ((graph (make-hash-table :test 'eql))
                      (graph-data (read-input-graph n))
                      (order (kahn graph n)))
                 (if (stringp order)
                     (insert "Cyclic graph\n")
                   (insert (mapconcat 'number-to-string order " ") "\n"))))
      (write-region (point-min) (point-max) output-file))))

(defun read-input-graph (n)
  (let ((graph (make-hash-table :test 'eql)))
    (cl-loop while (> n 0) do
             (let* ((line (split-string (substring (thing-at-point 'line) 0 -1) " "))
                    (u (string-to-number (car line))
                    (v (string-to-number (cadr line))))
               (puthash u (cons v (gethash u graph '())) graph)
               (setq n (1- n))))
    graph))

(main)
