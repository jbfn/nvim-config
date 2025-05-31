;; extends

;; Function parameter `self` or `cls`
(function_definition
    parameters: (parameters
	(identifier) @jbfn.type.parameter.self 
	    (#any-of? @jbfn.type.parameter.self "self" "cls")
	    (#set! priority 200)
    )
)

