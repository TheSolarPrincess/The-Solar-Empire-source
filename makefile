deploy:
	emacsclient --no-wait --alternate-editor="" --eval "\
	(with-current-buffer (find-file-noselect \"compile.org\") \
		(let ((org-confirm-babel-evaluate nil) \
			(org-publish-use-timestamps-flag nil)) \
			(org-babel-goto-named-src-block \"export\") \
			(org-babel-execute-src-block)))"
update:
	emacsclient --no-wait --alternate-editor="" --eval "\
	(with-current-buffer (find-file-noselect \"compile.org\") \
		(let ((org-confirm-babel-evaluate nil) \
			(org-publish-use-timestamps-flag t)) \
			(org-babel-goto-named-src-block \"export\") \
			(org-babel-execute-src-block)))"
