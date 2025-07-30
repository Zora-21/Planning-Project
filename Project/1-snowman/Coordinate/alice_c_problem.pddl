(define (problem alice-adapted-for-coordinates)
    (:domain one_snowman_coordinates)

    (:objects
        ;; Oggetti del problema: 3 palle e 42 locazioni
        ball_0 ball_1 ball_2 - ball
        
        loc_1_2 loc_1_3 loc_1_4
        loc_2_2 loc_2_3 loc_2_4
        loc_3_2 loc_3_3 loc_3_4
        loc_4_3
        loc_5_1 loc_5_2 loc_5_3 loc_5_4 loc_5_5
        loc_6_1 loc_6_2 loc_6_3 loc_6_4 loc_6_5
        loc_7_1 loc_7_2 loc_7_3 loc_7_4 loc_7_5
        loc_8_3
        loc_9_2 loc_9_3 loc_9_4
        loc_10_2 loc_10_3 loc_10_4
        loc_11_2 loc_11_3 loc_11_4 - location
    )

    (:init
        ;; Inizializzazione dei valori numerici
        (= (total-cost) 0)
        (= (goal) 0)

        ;; Definizione delle coordinate per ogni locazione
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_3_2) 3) (= (y-coord loc_3_2) 2)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_4) 3) (= (y-coord loc_3_4) 4)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)
        (= (x-coord loc_6_1) 6) (= (y-coord loc_6_1) 1)
        (= (x-coord loc_6_2) 6) (= (y-coord loc_6_2) 2)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_6_4) 6) (= (y-coord loc_6_4) 4)
        (= (x-coord loc_6_5) 6) (= (y-coord loc_6_5) 5)
        (= (x-coord loc_7_1) 7) (= (y-coord loc_7_1) 1)
        (= (x-coord loc_7_2) 7) (= (y-coord loc_7_2) 2)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_7_4) 7) (= (y-coord loc_7_4) 4)
        (= (x-coord loc_7_5) 7) (= (y-coord loc_7_5) 5)
        (= (x-coord loc_8_3) 8) (= (y-coord loc_8_3) 3)
        (= (x-coord loc_9_2) 9) (= (y-coord loc_9_2) 2)
        (= (x-coord loc_9_3) 9) (= (y-coord loc_9_3) 3)
        (= (x-coord loc_9_4) 9) (= (y-coord loc_9_4) 4)
        (= (x-coord loc_10_2) 10) (= (y-coord loc_10_2) 2)
        (= (x-coord loc_10_3) 10) (= (y-coord loc_10_3) 3)
        (= (x-coord loc_10_4) 10) (= (y-coord loc_10_4) 4)
        (= (x-coord loc_11_2) 11) (= (y-coord loc_11_2) 2)
        (= (x-coord loc_11_3) 11) (= (y-coord loc_11_3) 3)
        (= (x-coord loc_11_4) 11) (= (y-coord loc_11_4) 4)

        ;; Stato iniziale del mondo
        (character_at loc_6_2)

        (ball_at ball_0 loc_2_3)
        (= (ball_size ball_0) 1)
        (ball_at ball_1 loc_6_4)
        (= (ball_size ball_1) 1)
        (ball_at ball_2 loc_10_3)
        (= (ball_size ball_2) 1)

        (is_movable ball_0)
        (is_movable ball_1)
        (is_movable ball_2)

        (occupancy loc_2_3)
        (occupancy loc_6_4)
        (occupancy loc_10_3)

        (snow loc_1_2) (snow loc_1_3) (snow loc_1_4)
        (snow loc_2_2) (snow loc_2_4)
        (snow loc_3_2) (snow loc_3_3) (snow loc_3_4)
        (snow loc_4_3)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_3) (snow loc_5_4) (snow loc_5_5)
        (snow loc_6_1) (snow loc_6_2) (snow loc_6_3) (snow loc_6_5)
        (snow loc_7_1) (snow loc_7_2) (snow loc_7_3) (snow loc_7_4) (snow loc_7_5)
        (snow loc_8_3)
        (snow loc_9_2) (snow loc_9_3) (snow loc_9_4)
        (snow loc_10_2) (snow loc_10_4)
        (snow loc_11_2) (snow loc_11_3) (snow loc_11_4)
    )

    (:goal
        (and
            (= (goal) 1)
        )
    )

    (:metric minimize (total-cost))
)