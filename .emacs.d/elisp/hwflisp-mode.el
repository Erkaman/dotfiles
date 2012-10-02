(defvar hwflisp-events
  '("LDA" "OEA" "LDT" "F3" "F2" "F1" "F0" "LDT" "CLRT" "LDR" "OER"
    "LDCC" "OECC" "LDX" "OEX" "LDY" "OEY" "LDSP" "INCSP" "DECSP"
    "OESP" "LDPC" "INCPC" "OEPC" "LDTA" "MW" "MR"
    "G1" "G2" "G3" "G4" "G5" "G6" "G7" "G8" "G9" "G10"
    "G11" "G12" "G13" "G14"
    "NF" "LDI"
    ))

(defvar hwflisp-font-lock-defaults
  `((
     ("\\(# MergeState\\)\\|\\(# load\\)\\|\\(#SetMemory\\)\\|\\(#ClearAll.+\\)" . font-lock-keyword-face)
     ("^[^#].*" . font-lock-comment-face)
     ( ,(regexp-opt hwflisp-events 'words) . font-lock-constant-face)
     )))

(define-derived-mode hwflisp-mode fundamental-mode "HWFLISP config"
  "Mode for editing HWFLISP config files. "
  (setq mode-name "HWFLISP config")
  (setq font-lock-defaults hwflisp-font-lock-defaults)
  )

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.hwflisp" . hwflisp-mode))

(provide 'hwflisp-mode)