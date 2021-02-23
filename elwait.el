;;; elwait.el --- Async/await with threads -*- lexical-binding: t -*-

;; Copyright (C) 2021 Sebastian Arlund Nørgaard

;; Author: Sebastian Arlund Nørgaard
;; Keywords: extensions, lisp
;; URL: https://github.com/northgaard/elwait
;; Package-Version: 0
;; Package-Requires: ((emacs "27.1"))

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Placeholder.

;;; Code:

(defgroup elwait nil
  "Customization group for elwait, and async/await library."
  :group 'extensions
  :group 'lisp
  :prefix "elwait-")

(defvar elwait--mutex (make-mutex "elwait-mutex")
  "Mutex used by elwait.")

(defvar elwait--condition-variable
  (make-condition-variable elwait--mutex "elwait-condition-variable")
  "Condition variable used by elwait.")

(defconst elwait-num-threads 2)

(defun elwait--thread-worker ()
  (with-mutex elwait--mutex
    (while t
      (condition-wait elwait--condition-variable))))

(defun elwait--create-thread-pool ()
  (mapcar (lambda (num)
            (make-thread #'elwait--thread-worker
                         (format "elwait-thread-%d" num)))
          (number-sequence 1 elwait-num-threads)))

(defvar elwait--thread-pool
  (elwait--create-thread-pool)
  "Thread pool used by elwait.")

(provide 'elwait)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; require-final-newline: t
;; End:

;;; elwait.el ends here
