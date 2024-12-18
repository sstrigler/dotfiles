;;; core-display-init.el --- Spacemacs Core File -*- lexical-binding: t -*-
;;
;; Copyright (c) 2012-2024 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


(defvar spacemacs--after-display-system-init-list '()
  "List of functions to be run after the display system is initialized.")

(defun spacemacs--display-system-initialized-p ()
  "Dectect the display system initialized or not."
  (cond ((boundp 'ns-initialized) ns-initialized)
        ;; w32-initialized gets set too early, so
        ;; if we're on Windows, check the list of fonts
        ;; instead (this is nil until the graphics system
        ;; is initialized)
        ((boundp 'w32-initialized) (font-family-list))
        ((boundp 'x-initialized) x-initialized)
        ;; fallback to normal loading behavior only if in a GUI
        (t (display-graphic-p))))

(define-advice server-create-window-system-frame
    (:after (&rest _) spacemacs-init-display)
  "After Emacs server creates a frame, run functions queued in
`SPACEMACS--AFTER-DISPLAY-SYSTEM-INIT-LIST' to do any setup that needs to have
the display system initialized."
  (when (spacemacs--display-system-initialized-p)
    (mapc #'funcall (reverse spacemacs--after-display-system-init-list))
    (advice-remove 'server-create-window-system-frame
                   #'server-create-window-system-frame@spacemacs-init-display)))

(defmacro spacemacs|do-after-display-system-init (&rest body)
  "If the display-system is initialized, run `BODY', otherwise,
add it to a queue of actions to perform after the first graphical frame is
created."
  `(if (not (spacemacs--display-system-initialized-p))
       (push (lambda () ,@body) spacemacs--after-display-system-init-list)
     ,@body))

(provide 'core-display-init)
