; Structure for modified SET/field gradient structure.
; C Webb z3288829
; Units in nanometers.
; Start of file is definitions (parameters and functions
; Devise structure is generated at the end of the file.

; Global parameters
  (define extend_far 400)
  (define top_gate_width 60)

; Create barrier. First create right, then mirror to create left.
(define create_barrier (lambda ()
  (isegeo:set-default-boolean "XX") ; Overlapping regions will trigger errors

  (define barrier_sep 90)
  (define barrier_width 30)
  (define barrier_height 30)
  (define barrier_overhang 5)

  ; Create right
  ; top left corner, bottom side
  (define corner_a_x (/ barrier_sep 2))
  (define corner_a_y  barrier_overhang)
  (define corner_a_z 0)

  ; bottom right corner, top side
  (define corner_b_x (+ barrier_width (/ barrier_sep 2)))
  (define corner_b_y (- 0 extend_far))
  (define corner_b_z barrier_height)

  (define barrier_left_id (isegeo:create-cuboid
    (position corner_a_x corner_a_y corner_a_z) 
    (position corner_b_x corner_b_y corner_b_z) 
    "Aluminum"
    "barrier_left_Al"))

  ; Create left: mirror right barrier around y-plane
  (define mirror (transform:reflection (position 0 0 0) (gvector 1 0 0)))
  (isegeo:mirror-selected barrier_left_id mirror #t)

  ))

; create top gate on layer 2, along with the oxide
(define create_top_gate (lambda ()
  (isegeo:set-default-boolean "BAB") ; subtract overlaps from top_gate

  (define top_gate_height 60)

  ; top left corner, bottom side
  (define corner_a_x (- 0 extend_far))
  (define corner_a_y 0)
  (define corner_a_z 0)

  ; bottom right corner, top side
  (define corner_b_x extend_far)
  (define corner_b_y (- 0 top_gate_width))
  (define corner_b_z top_gate_height)

  (isegeo:create-cuboid
    (position corner_a_x corner_a_y corner_a_z)
    (position corner_b_x corner_b_y corner_b_z)
    "Aluminum"
    "top_gate")

  ))

(define create_plunger (lambda ()
  (isegeo:set-default-boolean "XX") ; Overlapping regions will trigger errors

  (define plunger_top_gate_sep 50)
  (define plunger_width 30)
  (define plunger_height 30)

  ; top left corner, bottom side
  (define corner_a_x (/ plunger_width -2))
  (define corner_a_y extend_far)
  (define corner_a_z 0)

  ; bottom right corner, top side
  (define corner_b_x (/ plunger_width 2))
  (define corner_b_y plunger_top_gate_sep)
  (define corner_b_z plunger_height)

  (isegeo:create-cuboid
    (position corner_a_x corner_a_y corner_a_z)
    (position corner_b_x corner_b_y corner_b_z)
    "Aluminum"
    "plunger"
  )

  ))

(define create_side_gate (lambda ()
  (isegeo:set-default-boolean "XX") ; Overlapping regions will trigger errors

  (define side_gate_top_gate_sep 30)
  (define side_gate_sep 30)
  (define side_gate_width 30)
  (define side_gate_height 60)

  ; Create right side gate
  ; top left corner, bottom side
  (define corner_a_x (/ side_gate_sep 2))
  (define corner_a_y (+ side_gate_top_gate_sep side_gate_width))
  (define corner_a_z 0)

  ; bottom right corner, top side
  (define corner_b_x extend_far)
  (define corner_b_y side_gate_top_gate_sep)
  (define corner_b_z side_gate_height)

  (define side_gate_id (isegeo:create-cuboid
    (position corner_a_x corner_a_y corner_a_z)
    (position corner_b_x corner_b_y corner_b_z)
    "Aluminum"
    "side_gate"))

  ; Create left: mirror right barrier around y-plane
  (define mirror (transform:reflection (position 0 0 0) (gvector 1 0 0)))
  (isegeo:mirror-selected side_gate_id mirror #t)

  ))

; create substrate and layers on the oxide
(define create_substrate (lambda ()
  (define domainWidth 1000)
  (define domainLength 1000)
  (define substrateHeight 500)

  (define domainX1 (/ domainWidth -2))
  (define domainY1 (/ domainLength -2))
  (define domainX2 (/ domainWidth 2))
  (define domainY2 (/ domainLength 2))

  (isegeo:set-default-boolean "ABA") ; remove everything here
  (define substateID
    (isegeo:create-cuboid
      (position domainX1 domainY1 0)
      (position domainX2 domainY2 (- substrateHeight))
      "Silicon"
      "substrate"))
  ))

; Run DEVISE commands
(ise:clear) ; Reset DEVISE

(create_barrier)
(create_top_gate)

(create_plunger)
(create_side_gate)

(create_substrate)

(ise:save-model "quad")
