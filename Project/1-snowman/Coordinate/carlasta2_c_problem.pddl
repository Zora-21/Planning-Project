(define (problem carlasta_snow_coordinates)
    (:domain one_snowman_coordinates)
    (:objects
        ball_0 - ball
        ball_1 - ball
        ball_2 - ball
        loc_1_1 loc_1_2 loc_1_3 loc_1_4 loc_1_5 loc_1_6 loc_1_7 loc_1_8 - location
        loc_2_1 loc_2_2 loc_2_3 loc_2_4 loc_2_5 loc_2_6 loc_2_7 loc_2_8 - location
        loc_3_3 loc_3_6 - location
        loc_4_1 loc_4_2 loc_4_3 loc_4_4 loc_4_5 loc_4_6 loc_4_7 loc_4_8 - location
        loc_5_1 loc_5_2 loc_5_3 loc_5_4 loc_5_5 loc_5_6 loc_5_7 loc_5_8 - location
        loc_6_3 loc_6_6 - location
        loc_7_1 loc_7_2 loc_7_3 loc_7_4 loc_7_5 loc_7_6 loc_7_7 loc_7_8 - location
        loc_8_1 loc_8_2 loc_8_3 loc_8_4 loc_8_5 loc_8_6 loc_8_7 loc_8_8 - location
    )
    (:init
        ;; Funzioni numeriche iniziali
        (= (total-cost) 0)
        (= (goal) 0)

        ;; Definizione delle coordinate per ogni location
        (= (x-coord loc_1_1) 1) (= (y-coord loc_1_1) 1)
        (= (x-coord loc_1_2) 1) (= (y-coord loc_1_2) 2)
        (= (x-coord loc_1_3) 1) (= (y-coord loc_1_3) 3)
        (= (x-coord loc_1_4) 1) (= (y-coord loc_1_4) 4)
        (= (x-coord loc_1_5) 1) (= (y-coord loc_1_5) 5)
        (= (x-coord loc_1_6) 1) (= (y-coord loc_1_6) 6)
        (= (x-coord loc_1_7) 1) (= (y-coord loc_1_7) 7)
        (= (x-coord loc_1_8) 1) (= (y-coord loc_1_8) 8)
        (= (x-coord loc_2_1) 2) (= (y-coord loc_2_1) 1)
        (= (x-coord loc_2_2) 2) (= (y-coord loc_2_2) 2)
        (= (x-coord loc_2_3) 2) (= (y-coord loc_2_3) 3)
        (= (x-coord loc_2_4) 2) (= (y-coord loc_2_4) 4)
        (= (x-coord loc_2_5) 2) (= (y-coord loc_2_5) 5)
        (= (x-coord loc_2_6) 2) (= (y-coord loc_2_6) 6)
        (= (x-coord loc_2_7) 2) (= (y-coord loc_2_7) 7)
        (= (x-coord loc_2_8) 2) (= (y-coord loc_2_8) 8)
        (= (x-coord loc_3_3) 3) (= (y-coord loc_3_3) 3)
        (= (x-coord loc_3_6) 3) (= (y-coord loc_3_6) 6)
        (= (x-coord loc_4_1) 4) (= (y-coord loc_4_1) 1)
        (= (x-coord loc_4_2) 4) (= (y-coord loc_4_2) 2)
        (= (x-coord loc_4_3) 4) (= (y-coord loc_4_3) 3)
        (= (x-coord loc_4_4) 4) (= (y-coord loc_4_4) 4)
        (= (x-coord loc_4_5) 4) (= (y-coord loc_4_5) 5)
        (= (x-coord loc_4_6) 4) (= (y-coord loc_4_6) 6)
        (= (x-coord loc_4_7) 4) (= (y-coord loc_4_7) 7)
        (= (x-coord loc_4_8) 4) (= (y-coord loc_4_8) 8)
        (= (x-coord loc_5_1) 5) (= (y-coord loc_5_1) 1)
        (= (x-coord loc_5_2) 5) (= (y-coord loc_5_2) 2)
        (= (x-coord loc_5_3) 5) (= (y-coord loc_5_3) 3)
        (= (x-coord loc_5_4) 5) (= (y-coord loc_5_4) 4)
        (= (x-coord loc_5_5) 5) (= (y-coord loc_5_5) 5)
        (= (x-coord loc_5_6) 5) (= (y-coord loc_5_6) 6)
        (= (x-coord loc_5_7) 5) (= (y-coord loc_5_7) 7)
        (= (x-coord loc_5_8) 5) (= (y-coord loc_5_8) 8)
        (= (x-coord loc_6_3) 6) (= (y-coord loc_6_3) 3)
        (= (x-coord loc_6_6) 6) (= (y-coord loc_6_6) 6)
        (= (x-coord loc_7_1) 7) (= (y-coord loc_7_1) 1)
        (= (x-coord loc_7_2) 7) (= (y-coord loc_7_2) 2)
        (= (x-coord loc_7_3) 7) (= (y-coord loc_7_3) 3)
        (= (x-coord loc_7_4) 7) (= (y-coord loc_7_4) 4)
        (= (x-coord loc_7_5) 7) (= (y-coord loc_7_5) 5)
        (= (x-coord loc_7_6) 7) (= (y-coord loc_7_6) 6)
        (= (x-coord loc_7_7) 7) (= (y-coord loc_7_7) 7)
        (= (x-coord loc_7_8) 7) (= (y-coord loc_7_8) 8)
        (= (x-coord loc_8_1) 8) (= (y-coord loc_8_1) 1)
        (= (x-coord loc_8_2) 8) (= (y-coord loc_8_2) 2)
        (= (x-coord loc_8_3) 8) (= (y-coord loc_8_3) 3)
        (= (x-coord loc_8_4) 8) (= (y-coord loc_8_4) 4)
        (= (x-coord loc_8_5) 8) (= (y-coord loc_8_5) 5)
        (= (x-coord loc_8_6) 8) (= (y-coord loc_8_6) 6)
        (= (x-coord loc_8_7) 8) (= (y-coord loc_8_7) 7)
        (= (x-coord loc_8_8) 8) (= (y-coord loc_8_8) 8)

        ;; Stato iniziale del mondo
        (character_at loc_5_6)

        (ball_at ball_0 loc_2_5)
        (=(ball_size ball_0) 1)

        (ball_at ball_1 loc_2_6)
        (=(ball_size ball_1) 1)
        
        (ball_at ball_2 loc_2_7)
        (=(ball_size ball_2) 1)

        (occupancy loc_2_5)
        (occupancy loc_2_6)
        (occupancy loc_2_7)
        
        ;; Nuova distribuzione della neve (abbondante)
        (snow loc_4_1) (snow loc_4_2) (snow loc_4_3) (snow loc_4_4)
        (snow loc_4_5) (snow loc_4_6) (snow loc_4_7) (snow loc_4_8)
        (snow loc_5_1) (snow loc_5_2) (snow loc_5_3) (snow loc_5_4)
        (snow loc_5_5) (snow loc_5_7) (snow loc_5_8)
        (snow loc_6_3) (snow loc_6_6)
        (snow loc_7_1) (snow loc_7_2) (snow loc_7_3) (snow loc_7_4)
        (snow loc_7_5) (snow loc_7_6) (snow loc_7_7) (snow loc_7_8)
        (snow loc_8_1) (snow loc_8_2) (snow loc_8_3) (snow loc_8_4)
        (snow loc_8_5) (snow loc_8_6) (snow loc_8_7) (snow loc_8_8)
    )

    (:goal
        (and
            (=(goal) 1)
        )
    )

    (:metric minimize (total-cost))
)