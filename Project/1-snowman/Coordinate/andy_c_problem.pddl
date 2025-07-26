(define (problem andy-adapted-for-coordinates)
    (:domain one_snowman_coordinates)

    (:objects
        ;; Oggetti del problema: 3 palle e 25 locazioni in una griglia 5x5
        ball_0 ball_1 ball_2 - ball
        
        loc_1_1 loc_1_2 loc_1_3 loc_1_4 loc_1_5
        loc_2_1 loc_2_2 loc_2_3 loc_2_4 loc_2_5
        loc_3_1 loc_3_2 loc_3_3 loc_3_4 loc_3_5
        loc_4_1 loc_4_2 loc_4_3 loc_4_4 loc_4_5
        loc_5_1 loc_5_2 loc_5_3 loc_5_4 loc_5_5 - location
    )

    (:init
        ;; Inizializzazione dei valori numerici
        (= (total-cost) 0)
        (= (is_goal_achieved) 0)

        ;; Definizione delle coordinate per ogni locazione
        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_2_5) 2) (= (y-coord loc_2_5) 5)
        (= (x-coord loc_3_1) 3) (= (y-coord loc_3_1) 1)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_3_5) 3) (= (y-coord loc_3_5) 5)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)

        ;; Stato iniziale del mondo
        (character_at loc_3_3)

        (ball_at ball_0 loc_2_2)
        (= (ball_size ball_0) 1)
        (ball_at ball_1 loc_2_4)
        (= (ball_size ball_1) 1)
        (ball_at ball_2 loc_4_4)
        (= (ball_size ball_2) 1)
        
        (occupancy loc_2_2)
        (occupancy loc_2_4)
        (occupancy loc_4_4)
        
        (snow loc_1_2)
        (snow loc_1_3)
        (snow loc_1_4)
        (snow loc_1_5)
        (snow loc_2_3)
        (snow loc_2_5)
        (snow loc_3_3)
        (snow loc_3_4)
        (snow loc_3_5)
        (snow loc_4_1)
        (snow loc_4_5)
        (snow loc_5_1)
        (snow loc_5_5)
    )

    (:goal
        (and
            ;; L'obiettivo è che la condizione di goal definita nell'azione apposita sia soddisfatta
            (= (is_goal_achieved) 1)
        )
    )

    (:metric minimize (total-cost))
)