; Structure for modified SET/field gradient structure.
; C Webb z3288829
; Units in nanometers.
; Start of file is definitions (parameters and functions
; Devise structure is generated at the end of the file.

; Global parameters
  (define extend_far 400)
  (define oxide_thickness 3)
  (define ot oxide_thickness)
  (define delta (+ ot 1)) ; for finding Al bodies

; Create barrier. First create right, then mirror to create left.
; Call after making top-gate
(define create_barrier (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define barrier_sep 90)
  (define barrier_width 30)
  (define barrier_height 30)
  (define barrier_overhang 30)

  ; top left corner, bottom side
  (define a_x (/ barrier_sep 2))
  (define a_y  barrier_overhang)
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x (+ barrier_width (/ barrier_sep 2)))
  (define b_y (- extend_far))
  (define b_z barrier_height)

  ; Create right barrier insulator shell
  ; (isegeo:set-default-boolean "ABA") ; Subtract from top-gate
  (define barrier_right_insulator_id (isegeo:create-cuboid
    (position a_x a_y a_z) 
    (position b_x b_y b_z) 
    "Insulator1"
    "barrier_right_insulator"))

  ; Create right barrier aluminum
  (isegeo:set-default-boolean "ABA") ; Subtract from shell.
  (define barrier_right_id (isegeo:create-cuboid
    (position (+ a_x ot) (- a_y ot) a_z)
    (position (- b_x ot) b_y (- b_z ot))
    "Aluminum"
    "barrier_right"))

  ; flip x-coord around y-z plane
  ; note that now a_x is the right x corner, and b_x is the left x_corner
  (define a_x (- a_x))
  (define b_x (- b_x))
  ; Create left barrier insulator shell
  (isegeo:set-default-boolean "ABA") ; Subtract from top-gate
  (define barrier_left_insulator_id (isegeo:create-cuboid
    (position a_x a_y a_z) 
    (position b_x b_y b_z) 
    "Insulator1"
    "barrier_left_insulator"))

  ; Create left barrier aluminum
  (isegeo:set-default-boolean "ABA") ; Subtract from shell.
  (define barrier_left_id (isegeo:create-cuboid
    (position (- a_x ot) (- a_y ot) a_z)
    (position (+ b_x ot) b_y (- b_z ot))
    "Aluminum"
    "barrier_left"))

  ; Create left: mirror right barrier around y-plane
  ;(define mirror (transform:reflection (position 0 0 0) (gvector 1 0 0)))
  ;(define parts (list barrier_right_id barrier_right_insulator_id))
  ;(isegeo:mirror-selected parts mirror #t)

  (create_contact_set barrier_right_id "barrier_right")
  (create_contact_set barrier_left_id "barrier_left")

  ))

; create top gate on layer 2, along with the oxide
; Call before making barrier.
(define create_top_gate (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define top_gate_height 60)
  (define top_gate_width 60)

  ; top left corner, bottom side
  (define a_x (- extend_far))
  (define a_y 0)
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x extend_far)
  (define b_y (- top_gate_width))
  (define b_z top_gate_height)

  ; Fill in aluminum in shell.
  (isegeo:set-default-boolean "BAB") ; Don't subtract from barrier.
  (define top_gate_id (isegeo:create-cuboid
    (position a_x (- a_y ot) a_z)
    (position b_x (+ b_y ot) (- b_z ot))
    "Aluminum"
    "top_gate"))

  (create_contact_set top_gate_id "top_gate")

  ; Create insulator shell.
  (isegeo:set-default-boolean "BAB") ; Don't subtract from barrier.
  (isegeo:create-cuboid
    (position a_x a_y a_z)
    (position b_x b_y b_z)
    "Insulator1"
    "top_gate_insulator")

  ))

(define create_plunger (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define plunger_top_gate_sep 80)
  (define plunger_width 30)
  (define plunger_height 30)

  ; top left corner, bottom side
  (define a_x (/ plunger_width -2))
  (define a_y extend_far)
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x (/ plunger_width 2))
  (define b_y plunger_top_gate_sep)
  (define b_z plunger_height)

  ; Create shell
  (isegeo:create-cuboid
    (position a_x a_y a_z)
    (position b_x b_y b_z)
    "Insulator1"
    "plunger_insulator")

  ; Fill in aluminum
  (isegeo:set-default-boolean "ABA") ; Subtract from shell
  (define plunger_id (isegeo:create-cuboid
    (position (+ a_x ot) a_y a_z)
    (position (- b_x ot) (+ b_y ot) (- b_z ot))
    "Aluminum"
    "plunger"))

  (create_contact_set plunger_id "plunger")

  ))

(define create_side_gate (lambda ()
  (isegeo:set-default-boolean "XX") ; Cause unintentional overlaps to trigger errors

  (define side_gate_top_gate_sep 40)
  (define side_gate_sep 50)
  (define side_gate_width 30)
  (define side_gate_height 60)

  ; Create right side gate
  ; top left corner, bottom side
  (define a_x (/ side_gate_sep 2))
  (define a_y (+ side_gate_top_gate_sep side_gate_width))
  (define a_z 0)

  ; bottom right corner, top side
  (define b_x extend_far)
  (define b_y side_gate_top_gate_sep)
  (define b_z side_gate_height)

  ; Create shell
  (define side_gate_insulator_id (isegeo:create-cuboid
    (position a_x a_y a_z)
    (position b_x b_y b_z)
    "Insulator1"
    "side_gate_right_insulator"))

  (isegeo:set-default-boolean "ABA") ; Subtract from shell
  (define side_gate_id (isegeo:create-cuboid
    (position (+ a_x ot) (- a_y ot) a_z)
    (position b_x (+ b_y ot) (- b_z ot))
    "Aluminum"
    "side_gate_right"))

  ; Create left: mirror right barrier around y-plane
  (define mirror (transform:reflection (position 0 0 0) (gvector 1 0 0)))
  (define parts (list side_gate_insulator_id side_gate_id))
  (define side_gate_left (isegeo:mirror-selected parts mirror #t))

  (create_contact_set side_gate_id "side_gate_right")
  (define a_x (- a_x)) ; flip a_x around y-z plane
  (define side_gate_left_faces (find-body-id (position (- a_x delta) (- a_y delta) (+ a_z delta))))
  (create_contact_set side_gate_left_faces "side_gate_left")

  ))

; create substrate and layers on the oxide
(define create_substrate (lambda ()
  (define domainWidth 1000)
  (define domainLength 1000)
  (define substrateHeight 200)

  (define domainX1 (/ domainWidth -2))
  (define domainY1 (/ domainLength -2))
  (define domainX2 (/ domainWidth 2))
  (define domainY2 (/ domainLength 2))

  (isegeo:set-default-boolean "ABA") ; remove everything here
  (isegeo:create-cuboid
    (position domainX1 domainY1 0)
    (position domainX2 domainY2 (- substrateHeight))
    "Silicon"
    "substrate")

  (isegeo:set-default-boolean "ABA") ; remove everything here
  (isegeo:create-cuboid
    (position domainX1 domainY1 0)
    (position domainX2 domainY2 (- oxide_thickness))
    "SiO2"
    "substrate_insulator")
  
  ))

(define create_contact_set (lambda (id_list name)
  (isegeo:define-contact-set "name")
  (isegeo:define-3d-contact (entity:faces id_list) name)

  ))

; Run DEVISE commands
  (ise:clear) ; Reset DEVISE

  ; Create structures
  (create_barrier)
  (create_top_gate)

  (create_plunger)
  (create_side_gate)

  (create_substrate)

  ; (create_refinement)
   
  (ise:save-model "quad")
