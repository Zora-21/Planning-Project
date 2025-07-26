(define (problem snowman_problem_for_final_domain)
    (:domain snowman_numeric_final) ; MODIFICA: Collegato al dominio finale corretto

    (:objects
        right - direction
        left - direction
        up - direction
        down - direction
        
        ball_0 ball_1 ball_2 ball_3 ball_4 ball_5 - ball

        loc_1_1 loc_1_2 loc_1_3 loc_1_4 loc_1_5 - location
        loc_2_1 loc_2_2 loc_2_3 loc_2_4 loc_2_5 - location
        loc_3_1 loc_3_2 loc_3_3 loc_3_4 loc_3_5 - location
        loc_4_1 loc_4_2 loc_4_3 loc_4_4 loc_4_5 - location
        loc_5_1 loc_5_2 loc_5_3 loc_5_4 loc_5_5 - location
    )

    (:init
        (= (total-cost) 0)
        (= (snowman_built) 0)

        ;; Definizione della griglia 5x5
        (next loc_1_1 loc_2_1 down) (next loc_2_1 loc_1_1 up)
        (next loc_1_1 loc_1_2 right)(next loc_1_2 loc_1_1 left)
        (next loc_1_2 loc_2_2 down) (next loc_2_2 loc_1_2 up)
        (next loc_1_2 loc_1_3 right)(next loc_1_3 loc_1_2 left)
        (next loc_1_3 loc_2_3 down) (next loc_2_3 loc_1_3 up)
        (next loc_1_3 loc_1_4 right) (next loc_1_4 loc_1_3 left)
        (next loc_1_4 loc_2_4 down) (next loc_2_4 loc_1_4 up)
        (next loc_1_4 loc_1_5 right) (next loc_1_5 loc_1_4 left)
        (next loc_1_5 loc_2_5 down) (next loc_2_5 loc_1_5 up)
        (next loc_2_1 loc_3_1 down) (next loc_3_1 loc_2_1 up)
        (next loc_2_1 loc_2_2 right) (next loc_2_2 loc_2_1 left)
        (next loc_2_2 loc_3_2 down) (next loc_3_2 loc_2_2 up)
        (next loc_2_2 loc_2_3 right) (next loc_2_3 loc_2_2 left)
        (next loc_2_3 loc_3_3 down) (next loc_3_3 loc_2_3 up)
        (next loc_2_3 loc_2_4 right) (next loc_2_4 loc_2_3 left)
        (next loc_2_4 loc_3_4 down) (next loc_3_4 loc_2_4 up)
        (next loc_2_4 loc_2_5 right) (next loc_2_5 loc_2_4 left)
        (next loc_2_5 loc_3_5 down) (next loc_3_5 loc_2_5 up)
        (next loc_3_1 loc_4_1 down) (next loc_4_1 loc_3_1 up)
        (next loc_3_1 loc_3_2 right) (next loc_3_2 loc_3_1 left)
        (next loc_3_2 loc_4_2 down) (next loc_4_2 loc_3_2 up)
        (next loc_3_2 loc_3_3 right) (next loc_3_3 loc_3_2 left)
        (next loc_3_3 loc_4_3 down) (next loc_4_3 loc_3_3 up)
        (next loc_3_3 loc_3_4 right) (next loc_3_4 loc_3_3 left)
        (next loc_3_4 loc_4_4 down) (next loc_4_4 loc_3_4 up)
        (next loc_3_4 loc_3_5 right) (next loc_3_5 loc_3_4 left)
        (next loc_3_5 loc_4_5 down) (next loc_4_5 loc_3_5 up)
        (next loc_4_1 loc_5_1 down) (next loc_5_1 loc_4_1 up)
        (next loc_4_1 loc_4_2 right) (next loc_4_2 loc_4_1 left)
        (next loc_4_2 loc_5_2 down) (next loc_5_2 loc_4_2 up)
        (next loc_4_2 loc_4_3 right) (next loc_4_3 loc_4_2 left)
        (next loc_4_3 loc_5_3 down) (next loc_5_3 loc_4_3 up)
        (next loc_4_3 loc_4_4 right) (next loc_4_4 loc_4_3 left)
        (next loc_4_4 loc_5_4 down) (next loc_5_4 loc_4_4 up)
        (next loc_4_4 loc_4_5 right) (next loc_4_5 loc_4_4 left)
        (next loc_4_5 loc_5_5 down) (next loc_5_5 loc_4_5 up)
        (next loc_5_1 loc_5_2 right) (next loc_5_2 loc_5_1 left)
        (next loc_5_2 loc_5_3 right) (next loc_5_3 loc_5_2 left)
        (next loc_5_3 loc_5_4 right) (next loc_5_4 loc_5_3 left)
        (next loc_5_4 loc_5_5 right) (next loc_5_5 loc_5_4 left)

        ;; Posizione iniziale del personaggio
        (character_at loc_3_3)

        
        (ball_at ball_0 loc_2_1) (= (ball_size ball_0) 1) (occupancy loc_2_1)
        (ball_at ball_1 loc_2_2) (= (ball_size ball_1) 1) (occupancy loc_2_2)
        (ball_at ball_2 loc_2_4) (= (ball_size ball_2) 1) (occupancy loc_2_4)
        (ball_at ball_3 loc_4_1) (= (ball_size ball_3) 1) (occupancy loc_4_1)
        (ball_at ball_4 loc_4_2) (= (ball_size ball_4) 1) (occupancy loc_4_2)
        (ball_at ball_5 loc_4_4) (= (ball_size ball_5) 1) (occupancy loc_4_4)

        ;; Posizioni con la neve (necessaria per far crescere le palle)
        (snow loc_1_3)
        (snow loc_1_4)
        (snow loc_1_5)
        (snow loc_2_3)
        (snow loc_2_5)
        (snow loc_3_1)
        (snow loc_3_2)
        (snow loc_3_3)
        (snow loc_3_4)
        (snow loc_3_5)
        (snow loc_4_3)
        (snow loc_4_5)
        (snow loc_5_3)
        (snow loc_5_4)
        (snow loc_5_5)
    )

    (:goal
        (=(snowman_built) 2) 
    )

    (:metric minimize (total-cost))
)