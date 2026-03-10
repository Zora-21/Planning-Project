package models;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SnowmanConfigurator {
    private final int numLocations;
    private final int numBalls;
    private final int maxSnowmen;

    public static final int UNREACHABLE = 100_000;

    private final List<Grouping> allGroupings;
    private final boolean[] isActiveBalls;
    private final boolean[] usedBalls;

    // Environment
    private boolean[] currentSnow;
    private boolean[] previousSnow;
    private final int[] activeSnowCells;
    private int numActiveSnowCells;
    private final int[][] distanceMatrix;

    // Caches per i detour sulla neve
    private final int[][] snowDetour1;
    private final int[][] snowDetour2;
    private final int[][] snow1ToCache;

    // Cache Transposizionale (Zero-Allocation)
    private static final int CACHE_SIZE = 1048576;
    private static final int CACHE_MASK = CACHE_SIZE - 1;
    private final long[] groupingCacheKeys;
    private final double[] groupingCacheValues;

    // Tracciatura del percorso ottimale (fondamentale per ENHSP-5)
    private double globalBestCost = Double.POSITIVE_INFINITY;
    private final Grouping[] currentPath;
    private final Grouping[] optimalGroupings;
    private long globalBestPathHash = Long.MAX_VALUE;

    private long snowFingerprint;

    public int getNumActiveSnowCells() {
        return numActiveSnowCells;
    }

    public long getSnowFingerprint() {
        return snowFingerprint;
    }

    // --- IL METODO CHE MANCAVA ---
    public Grouping[] getOptimalGroupings() {
        return optimalGroupings;
    }

    public void updateEnvironment(boolean[] currentSnow) {
        this.currentSnow = currentSnow;
        numActiveSnowCells = 0;
        long fp = 0;
        for (int s = 0; s < numLocations; s++) {
            if (this.currentSnow[s]) {
                activeSnowCells[numActiveSnowCells++] = s;
                fp = fp * 37 + s;
            }
        }
        this.snowFingerprint = fp;

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

            for (int st = 0; st < numLocations; st++) {
                Arrays.fill(snowDetour2[st], UNREACHABLE);
            }

            if (numActiveSnowCells >= 2) {
                for (int st = 0; st < numLocations; st++) {
                    Arrays.fill(snow1ToCache[st], UNREACHABLE);
                    for (int j = 0; j < numActiveSnowCells; j++) {
                        int s2 = activeSnowCells[j];
                        int minDist = UNREACHABLE;
                        for (int i = 0; i < numActiveSnowCells; i++) {
                            if (i == j)
                                continue; // s1 != s2
                            int s1 = activeSnowCells[i];
                            int dStart_s1 = distanceMatrix[st][s1];
                            int d_s1_s2 = distanceMatrix[s1][s2];
                            if (dStart_s1 < UNREACHABLE && d_s1_s2 < UNREACHABLE) {
                                int cost = dStart_s1 + d_s1_s2;
                                if (cost < minDist)
                                    minDist = cost;
                            }
                        }
                        snow1ToCache[st][s2] = minDist;
                    }
                }

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

            if (previousSnow == null)
                previousSnow = new boolean[numLocations];
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
        this.globalBestPathHash = Long.MAX_VALUE;

        // Inizializzazione array per la tracciatura
        this.currentPath = new Grouping[maxSnowmen];
        this.optimalGroupings = new Grouping[maxSnowmen];

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

        this.groupingCacheKeys = new long[CACHE_SIZE];
        this.groupingCacheValues = new double[CACHE_SIZE];
        Arrays.fill(this.groupingCacheKeys, -1L);
    }

    private long computeGroupHash(long snowFp, Ball b0, Ball b1, Ball b2) {
        long hash = snowFp;
        hash ^= (b0.getLocId() * 131L + b0.getSize()) * 1000000007L;
        hash ^= (b1.getLocId() * 131L + b1.getSize()) * 1000000009L;
        hash ^= (b2.getLocId() * 131L + b2.getSize()) * 1000000021L;
        hash ^= hash >>> 33;
        hash *= 0xff51afd7ed558ccdL;
        hash ^= hash >>> 33;
        hash *= 0xc4ceb9fe1a85ec53L;
        hash ^= hash >>> 33;
        return hash;
    }

    private final double[] precomputedGroupCosts;
    private final Grouping[] precomputedGroups;
    private final int[] sortedIndices;

    public double getBestScore(List<Ball> activeBalls, int targetSnowmen) {
        if (activeBalls.size() < 3 * targetSnowmen)
            return Double.POSITIVE_INFINITY;

        Arrays.fill(isActiveBalls, false);
        for (Ball b : activeBalls)
            isActiveBalls[b.getIntId()] = true;

        long snowFp = this.snowFingerprint;
        int validCount = 0;

        for (Grouping g : allGroupings) {
            int[] ids = g.getBallIntIds();
            if (isActiveBalls[ids[0]] && isActiveBalls[ids[1]] && isActiveBalls[ids[2]]) {
                Ball b0 = g.getBalls().get(0), b1 = g.getBalls().get(1), b2 = g.getBalls().get(2);
                long hash = computeGroupHash(snowFp, b0, b1, b2);
                int cacheIdx = (int) (hash & CACHE_MASK);

                double cost;
                if (groupingCacheKeys[cacheIdx] == hash) {
                    cost = groupingCacheValues[cacheIdx];
                } else {
                    cost = evaluateGrouping(g);
                    groupingCacheKeys[cacheIdx] = hash;
                    groupingCacheValues[cacheIdx] = cost;
                }

                precomputedGroups[validCount] = g;
                precomputedGroupCosts[validCount] = cost;
                sortedIndices[validCount] = validCount;
                validCount++;
            }
        }

        if (validCount == 0)
            return Double.POSITIVE_INFINITY;

        // Reset del tracking ottimale
        this.globalBestCost = Double.POSITIVE_INFINITY;
        Arrays.fill(optimalGroupings, null);

        if (targetSnowmen == 1) {
            double minCost = Double.POSITIVE_INFINITY;
            int bestIdx = -1;
            for (int i = 0; i < validCount; i++) {
                if (precomputedGroupCosts[i] < minCost) {
                    minCost = precomputedGroupCosts[i];
                    bestIdx = i;
                }
            }
            if (bestIdx != -1) {
                optimalGroupings[0] = precomputedGroups[bestIdx];
            }
            return minCost;
        }

        primitiveSort(sortedIndices, precomputedGroupCosts, 0, validCount - 1);
        Arrays.fill(usedBalls, false);
        // Passiamo la depth 0 per tracciare il percorso
        return backtrackRecursive(sortedIndices, validCount, 0, targetSnowmen, usedBalls, 0, 0);
    }

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

    private double backtrackRecursive(int[] sortedIndices, int validCount, int startIndex,
            int remainingTargets, boolean[] used, double currentCost, int depth) {

        // Salvataggio del raggruppamento ottimale assoluto
        if (remainingTargets == 0) {
            if (currentCost < this.globalBestCost) {
                this.globalBestCost = currentCost;
                System.arraycopy(this.currentPath, 0, this.optimalGroupings, 0, depth);
            }
            return currentCost;
        }

        double best = Double.POSITIVE_INFINITY;
        for (int i = startIndex; i < validCount; i++) {
            int idx = sortedIndices[i];
            double cost = precomputedGroupCosts[idx];

            if (currentCost + (cost * remainingTargets) >= best)
                break;
            if (currentCost + (cost * remainingTargets) >= this.globalBestCost)
                break;

            Grouping g = precomputedGroups[idx];
            int[] ids = g.getBallIntIds();
            if (used[ids[0]] || used[ids[1]] || used[ids[2]])
                continue;

            used[ids[0]] = true;
            used[ids[1]] = true;
            used[ids[2]] = true;
            currentPath[depth] = g;

            double res = backtrackRecursive(sortedIndices, validCount, i + 1,
                    remainingTargets - 1, used, currentCost + cost, depth + 1);
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
            int d0 = distanceMatrix[b0_loc][l];
            if (d0 >= UNREACHABLE)
                continue;
            int d1 = distanceMatrix[b1_loc][l];
            if (d1 >= UNREACHABLE)
                continue;
            int d2 = distanceMatrix[b2_loc][l];
            if (d2 >= UNREACHABLE)
                continue;

            if (d0 + d1 + d2 >= bestGroupCost)
                continue;

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

    private double computeSnowPathCost(Ball b, int targetL, int targetSize) {
        int startL = b.getLocId();
        int size = b.getSize();

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
                minSnowDetour = snowDetour1[startL][targetL];
            }

            if (minSnowDetour >= UNREACHABLE)
                return UNREACHABLE;
            return minSnowDetour;
        }
        return directCost;
    }
}