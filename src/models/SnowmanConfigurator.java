package models;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SnowmanConfigurator {
    private final int numLocations;
    private final int numBalls;
    private final int maxSnowmen;

    // Valore sentinella per coppie di nodi non connesse nella distanceMatrix.
    // DEVE coincidere con il valore UNREACHABLE usato in ENHSP.preprocessSnowman().
    // Qualsiasi distanza >= UNREACHABLE viene trattata come irraggiungibile.
    // Il valore 100_000 è scelto per essere > diametro massimo di qualsiasi
    // griglia del benchmark (max 99 nodi → diametro ≤ 98).
    public static final int UNREACHABLE = 100_000;

    private final List<Grouping> allGroupings;
    private final boolean[] isActiveBalls;
    private final boolean[] usedBalls;

    // Environment
    private boolean[] currentSnow;
    private boolean[] previousSnow; // Per lazy invalidation dei cache snowDetour
    private final int[] activeSnowCells;
    private int numActiveSnowCells;
    private final int[][] distanceMatrix;

    // Pre-computed snow detour caches (popolati in updateEnvironment,
    // lazy-invalidated)
    // snowDetour1[start][target] = min_s(D(start,s) + D(s,target)) per
    // missingSnow=1
    // snowDetour2[start][target] = min_{s1!=s2}(D(start,s1)+D(s1,s2)+D(s2,target))
    // per missingSnow=2
    // Entrambi sono O(1) lookups in computeSnowPathCost.
    private final int[][] snowDetour1;
    private final int[][] snowDetour2;
    private final int[][] snow1ToCache;

    // Fingerprint deterministico della neve corrente, calcolato in
    // updateEnvironment.
    // Usato in ENHSP per il caching di h_balls senza allocare array.
    private long snowFingerprint;

    public int getNumActiveSnowCells() {
        return numActiveSnowCells;
    }

    public long getSnowFingerprint() {
        return snowFingerprint;
    }

    public void updateEnvironment(boolean[] currentSnow) {
        this.currentSnow = currentSnow; // O(1) pass from ENHSP

        // Ricostruisce activeSnowCells e calcola il fingerprint in un unico loop O(L)
        numActiveSnowCells = 0;
        long fp = 0;
        for (int s = 0; s < numLocations; s++) {
            if (this.currentSnow[s]) {
                activeSnowCells[numActiveSnowCells++] = s;
                fp = fp * 37 + s; // ID reale della cella, non l'indice del loop
            }
        }
        this.snowFingerprint = fp;

        // Lazy invalidation: ricalcola i cache solo se la neve è effettivamente
        // cambiata
        boolean snowChanged = false;
        if (previousSnow == null) {
            snowChanged = true;
        } else {
            for (int s = 0; s < numLocations; s++) {
                if (previousSnow[s] != currentSnow[s]) {
                    snowChanged = true;
                    break;
                }
            }
        }

        if (snowChanged) {
            // Pre-calcola snowDetour1[start][target] = min_s(D(start,s) + D(s,target))
            // Costo: O(L² · |S|) — eseguito solo quando la neve cambia (raro: solo su
            // push-over-snow)
            for (int st = 0; st < numLocations; st++) {
                Arrays.fill(snowDetour1[st], UNREACHABLE);
            }
            for (int i = 0; i < numActiveSnowCells; i++) {
                int s = activeSnowCells[i];
                for (int st = 0; st < numLocations; st++) {
                    int dStart_s = distanceMatrix[st][s];
                    if (dStart_s >= UNREACHABLE)
                        continue;
                    for (int tg = 0; tg < numLocations; tg++) {
                        int d_s_tg = distanceMatrix[s][tg];
                        if (d_s_tg >= UNREACHABLE)
                            continue;
                        int detour = dStart_s + d_s_tg;
                        if (detour < snowDetour1[st][tg]) {
                            snowDetour1[st][tg] = detour;
                        }
                    }
                }
            }

            // Pre-calcola snowDetour2 con coppie distinte s1 != s2.
            // Costo: O(|S|² · L²) — ammortizzato trascurabile perché eseguito solo su
            // snowChanged.
            // CRITICO: il vincolo s1 != s2 garantisce che il lower bound per missingSnow=2
            // sia strettamente più tight di missingSnow=1, prevenendo la regressione dove
            // snowDetour2 <= snowDetour1 sempre (ammettendo s1==s2 azzera il contributo).
            // Pre-calcola snowDetour2: percorso che tocca s1 e s2 (con s1 != s2)
            for (int st = 0; st < numLocations; st++) {
                Arrays.fill(snowDetour2[st], UNREACHABLE);
            }

            if (numActiveSnowCells >= 2) {
                // Fase 1: Calcola la distanza minima da 'st' a 's2' passando per un 's1'
                // diverso da 's2'
                // USIAMO LA CACHE INVECE DI FARE 'new int[][]'
                for (int st = 0; st < numLocations; st++) {
                    Arrays.fill(snow1ToCache[st], UNREACHABLE); // Puliamo la cache
                    for (int j = 0; j < numActiveSnowCells; j++) {
                        int s2 = activeSnowCells[j];
                        int minDist = UNREACHABLE;

                        for (int i = 0; i < numActiveSnowCells; i++) {
                            if (i == j)
                                continue; // CRITICO: s1 != s2
                            int s1 = activeSnowCells[i];
                            int dStart_s1 = distanceMatrix[st][s1];
                            int d_s1_s2 = distanceMatrix[s1][s2];

                            if (dStart_s1 < UNREACHABLE && d_s1_s2 < UNREACHABLE) {
                                int cost = dStart_s1 + d_s1_s2;
                                if (cost < minDist)
                                    minDist = cost;
                            }
                        }
                        snow1ToCache[st][s2] = minDist; // Salviamo nella cache
                    }
                }

                // Fase 2: Calcola snowDetour2[st][tg] = min_s2 ( snow1To[st][s2] + D(s2, tg) )
                for (int st = 0; st < numLocations; st++) {
                    for (int j = 0; j < numActiveSnowCells; j++) {
                        int s2 = activeSnowCells[j];
                        int d1 = snow1ToCache[st][s2];
                        if (d1 >= UNREACHABLE)
                            continue;

                        for (int tg = 0; tg < numLocations; tg++) {
                            int d_s2_tg = distanceMatrix[s2][tg];
                            if (d_s2_tg >= UNREACHABLE)
                                continue;

                            int detour = d1 + d_s2_tg;
                            if (detour < snowDetour2[st][tg]) {
                                snowDetour2[st][tg] = detour;
                            }
                        }
                    }
                }
            }

            // Salva snapshot per il confronto al prossimo aggiornamento
            if (previousSnow == null) {
                previousSnow = new boolean[numLocations];
            }
            System.arraycopy(currentSnow, 0, previousSnow, 0, numLocations);
        }
    }

    public SnowmanConfigurator(int numLocations, List<Ball> allBalls, int targetSnowmen, int[][] distanceMatrix) {
        this.numLocations = numLocations;
        this.numBalls = allBalls.size();
        this.maxSnowmen = targetSnowmen;
        this.distanceMatrix = distanceMatrix;
        this.activeSnowCells = new int[numLocations];
        this.snowDetour1 = new int[numLocations][numLocations];
        this.snowDetour2 = new int[numLocations][numLocations];
        this.snow1ToCache = new int[numLocations][numLocations];
        this.isActiveBalls = new boolean[this.numBalls];
        this.usedBalls = new boolean[this.numBalls];

        this.allGroupings = new ArrayList<>();
        int n = allBalls.size();
        for (int i = 0; i < n - 2; i++) {
            for (int j = i + 1; j < n - 1; j++) {
                for (int k = j + 1; k < n; k++) {
                    allGroupings.add(new Grouping(allBalls.get(i), allBalls.get(j), allBalls.get(k)));
                }
            }
        }

        int maxGroups = allGroupings.size();
        this.precomputedGroupCosts = new double[maxGroups];
        this.precomputedGroups = new Grouping[maxGroups];
        this.sortedIndices = new int[maxGroups];

        System.out.println(
                "SnowmanConfigurator: initialized with " + allGroupings.size() + " groupings.");
    }

    public double getBestScore(List<Ball> activeBalls, int targetSnowmen) {
        if (activeBalls.size() < 3 * targetSnowmen)
            return Double.POSITIVE_INFINITY;

        Arrays.fill(isActiveBalls, false);
        for (Ball b : activeBalls)
            isActiveBalls[b.getIntId()] = true;

        int validCount = 0;
        for (Grouping g : allGroupings) {
            int[] ids = g.getBallIntIds();
            if (isActiveBalls[ids[0]] && isActiveBalls[ids[1]] && isActiveBalls[ids[2]]) {
                precomputedGroups[validCount] = g;
                precomputedGroupCosts[validCount] = evaluateGrouping(g);
                sortedIndices[validCount] = validCount;
                validCount++;
            }
        }

        if (validCount == 0)
            return Double.POSITIVE_INFINITY;

        if (targetSnowmen == 1) {
            double minCost = Double.POSITIVE_INFINITY;
            for (int i = 0; i < validCount; i++) {
                if (precomputedGroupCosts[i] < minCost)
                    minCost = precomputedGroupCosts[i];
            }
            return minCost;
        }

        // Backtracking multi-target con sort primitivo zero-allocation
        primitiveSort(sortedIndices, precomputedGroupCosts, 0, validCount - 1);
        Arrays.fill(usedBalls, false);
        return backtrackRecursive(sortedIndices, validCount, 0, targetSnowmen, usedBalls, 0);
    }

    private final double[] precomputedGroupCosts;
    private final Grouping[] precomputedGroups;
    private final int[] sortedIndices;

    private void primitiveSort(int[] indices, double[] keys, int left, int right) {
        int length = right - left + 1;
        if (length < 2)
            return;

        if (length < 32) {
            for (int i = left + 1; i <= right; i++) {
                int keyIndex = indices[i];
                double keyVal = keys[keyIndex];
                int j = i - 1;
                while (j >= left && keys[indices[j]] > keyVal) {
                    indices[j + 1] = indices[j];
                    j--;
                }
                indices[j + 1] = keyIndex;
            }
            return;
        }

        int pivotIndex = left + (right - left) / 2;
        double pivotValue = keys[indices[pivotIndex]];
        int i = left, j = right;
        while (i <= j) {
            while (keys[indices[i]] < pivotValue)
                i++;
            while (keys[indices[j]] > pivotValue)
                j--;
            if (i <= j) {
                int temp = indices[i];
                indices[i] = indices[j];
                indices[j] = temp;
                i++;
                j--;
            }
        }
        primitiveSort(indices, keys, left, j);
        primitiveSort(indices, keys, i, right);
    }

    private double backtrackRecursive(int[] sortedIndices, int validCount, int startIndex, int remainingTargets,
            boolean[] used, double currentCost) {
        if (remainingTargets == 0)
            return currentCost;

        double best = Double.POSITIVE_INFINITY;
        for (int i = startIndex; i < validCount; i++) {
            int idx = sortedIndices[i];
            double cost = precomputedGroupCosts[idx];

            // Branch and bound: lista ordinata per costo crescente, quindi non può
            // migliorare
            if (currentCost + cost >= best)
                break;

            Grouping g = precomputedGroups[idx];
            int[] ids = g.getBallIntIds();

            if (used[ids[0]] || used[ids[1]] || used[ids[2]])
                continue;

            used[ids[0]] = true;
            used[ids[1]] = true;
            used[ids[2]] = true;

            double res = backtrackRecursive(sortedIndices, validCount, i + 1, remainingTargets - 1, used,
                    currentCost + cost);
            if (res < best)
                best = res;

            used[ids[0]] = false;
            used[ids[1]] = false;
            used[ids[2]] = false;
        }
        return best;
    }

    private double evaluateGrouping(Grouping group) {
        List<Ball> balls = group.getBalls();
        Ball b0 = balls.get(0), b1 = balls.get(1), b2 = balls.get(2);
        int b0_loc = b0.getLocId(), b1_loc = b1.getLocId(), b2_loc = b2.getLocId();

        double bestGroupCost = Double.POSITIVE_INFINITY;

        for (int l = 0; l < numLocations; l++) {

            // 1. Pruning di raggiungibilità: se una palla non può raggiungere l, salta
            int d0 = distanceMatrix[b0_loc][l];
            if (d0 >= UNREACHABLE)
                continue;
            int d1 = distanceMatrix[b1_loc][l];
            if (d1 >= UNREACHABLE)
                continue;
            int d2 = distanceMatrix[b2_loc][l];
            if (d2 >= UNREACHABLE)
                continue;

            // 2. Spatial meeting point pruning O(1):
            // Per disuguaglianza triangolare, qualsiasi percorso (anche con deviazioni
            // neve)
            // è >= distanza diretta. Quindi la somma totale >= d0 + d1 + d2.
            if (d0 + d1 + d2 >= bestGroupCost)
                continue;

            // 3. Calcola costi per ciascuna palla × ciascun ruolo (Base=3, Mid=2, Top=1)
            double c0_3 = computeSnowPathCost(b0, l, 3);
            double c0_2 = computeSnowPathCost(b0, l, 2);
            double c0_1 = computeSnowPathCost(b0, l, 1);
            double minC0 = Math.min(c0_3, Math.min(c0_2, c0_1));
            if (minC0 >= bestGroupCost)
                continue;

            double c1_3 = computeSnowPathCost(b1, l, 3);
            double c1_2 = computeSnowPathCost(b1, l, 2);
            double c1_1 = computeSnowPathCost(b1, l, 1);
            double minC1 = Math.min(c1_3, Math.min(c1_2, c1_1));
            if (minC0 + minC1 >= bestGroupCost)
                continue;

            double c2_3 = computeSnowPathCost(b2, l, 3);
            double c2_2 = computeSnowPathCost(b2, l, 2);
            double c2_1 = computeSnowPathCost(b2, l, 1);

            // 4. Valuta tutte le 6 permutazioni di ruoli sui 3 ball
            double p0 = c0_3 + c1_2 + c2_1;
            double p1 = c0_3 + c1_1 + c2_2;
            double p2 = c0_2 + c1_3 + c2_1;
            double p3 = c0_2 + c1_1 + c2_3;
            double p4 = c0_1 + c1_3 + c2_2;
            double p5 = c0_1 + c1_2 + c2_3;

            double minPermCost = Math.min(p0, Math.min(p1, Math.min(p2, Math.min(p3, Math.min(p4, p5)))));
            if (minPermCost < bestGroupCost) {
                bestGroupCost = minPermCost;
            }
        }
        return bestGroupCost;
    }

    /**
     * Calcola il costo minimo ammissibile per una palla 'b' per raggiungere
     * 'targetL' crescendo alla dimensione richiesta 'targetSize'.
     * Usa i cache pre-computati snowDetour1/snowDetour2 per lookup O(1).
     */
    private double computeSnowPathCost(Ball b, int targetL, int targetSize) {
        int startL = b.getLocId();
        int size = b.getSize();

        // Dead-end: la palla non può rimpicciolire
        if (size > targetSize)
            return UNREACHABLE;

        double directCost = distanceMatrix[startL][targetL];

        if (size < targetSize) {
            int missingSnow = targetSize - size;

            int minSnowDetour;
            if (missingSnow == 1) {
                minSnowDetour = snowDetour1[startL][targetL];
            } else if (missingSnow == 2) {
                minSnowDetour = snowDetour2[startL][targetL];
            } else {
                // missingSnow > 2 non dovrebbe accadere (diff max = 2), fallback conservativo
                minSnowDetour = snowDetour1[startL][targetL];
            }

            if (minSnowDetour >= UNREACHABLE)
                return UNREACHABLE; // Dead-end: neve insufficiente raggiungibile

            // Per disuguaglianza triangolare minSnowDetour >= directCost sempre.
            return minSnowDetour;
        }

        return directCost;
    }
}
