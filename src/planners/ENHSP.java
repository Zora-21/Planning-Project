
package planners;

/* 
 * Copyright (C) 2015-2017, Enrico Scala, contact: enricos83@gmail.com
 * Modified for Snowman Heuristic Extension, 2026
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 * 
 */
import com.hstairs.ppmajal.conditions.BoolPredicate;
import com.hstairs.ppmajal.conditions.PDDLObject;
import com.hstairs.ppmajal.domain.PDDLDomain;
import com.hstairs.ppmajal.expressions.NumFluent;
import com.hstairs.ppmajal.pddl.heuristics.PDDLHeuristic;
import com.hstairs.ppmajal.problem.PDDLObjects;
import com.hstairs.ppmajal.problem.PDDLProblem;
import com.hstairs.ppmajal.problem.PDDLSearchEngine;
import com.hstairs.ppmajal.problem.PDDLState;
import com.hstairs.ppmajal.problem.State;
import com.hstairs.ppmajal.search.SearchEngine;
import com.hstairs.ppmajal.search.SearchHeuristic;
import com.hstairs.ppmajal.transition.TransitionGround;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.lang3.tuple.Pair;

import models.Ball;
import models.SnowmanConfigurator;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ENHSP {
    private int plateau;
    private static final int PLATEAU = 10000;
    private Boolean exploration = false;
    private String domainFile;
    private String problemFile;
    private String searchEngineString;
    private String hw;
    private String heuristic = "aibr";
    private String gw;
    private boolean saving_json = false;
    private String deltaExecution;
    private float depthLimit;
    private String savePlan;
    private boolean printTrace;
    private String tieBreaking;
    private String planner;
    private String deltaHeuristic;
    private String deltaPlanning;
    private String deltaValidation;
    private boolean helpfulActionsPruning;
    private Integer numSubdomains;
    private SearchHeuristic heuristicFunction;
    private PDDLProblem problem;
    private boolean pddlPlus;
    private PDDLDomain domain;
    private PDDLDomain domainHeuristic;
    private PDDLProblem heuristicProblem;
    private long overallStart;
    private boolean copyOfTheProblem;
    private boolean anyTime;
    private long timeOut;
    private boolean aibrPreprocessing;
    private SearchHeuristic h;
    private long overallPlanningTime;
    private float endGValue;
    private boolean helpfulTransitions;
    private boolean internalValidation = false;
    private int planLength;
    private String redundantConstraints;
    private String groundingType;
    private boolean naiveGrounding;
    private boolean stopAfterGrounding;
    private boolean printEvents;
    private boolean sdac;
    private boolean onlyPlan;
    private boolean ignoreMetric;

    // ==================================================================================
    // Campi specifici per il dominio Snowman
    // ==================================================================================

    private List<String> ballNames = new ArrayList<>();
    private int targetSnowmen = 0;

    // Copia instance-level dei fluenti booleani groundati per evitare accesso
    // statico
    private HashSet<com.hstairs.ppmajal.conditions.BoolPredicate> groundedBooleanFluents;

    // Matrice All-Pairs Shortest Path basata sul predicato "next"
    private int[][] distanceMatrix;

    // Nodi dead-end: un nodo in cui una palla, una volta spinta, non può più
    // uscire.
    // Pre-computato in preprocessSnowman(). Attualmente usato solo per logging.
    // TODO: integrare nel dead-end check di computeEstimate per pruning aggiuntivo.
    private boolean[] isDeadEndNode;

    public ENHSP(boolean copyProblem) {
        copyOfTheProblem = copyProblem;
    }

    public int getPlanLength() {
        return planLength;
    }

    public Pair<PDDLDomain, PDDLProblem> parseDomainProblem(String domainFile, String problemFile, String delta,
            PrintStream out) {
        try {
            final PDDLDomain localDomain = new PDDLDomain(domainFile);
            pddlPlus = !localDomain.getProcessesSchema().isEmpty() || !localDomain.getEventsSchema().isEmpty();
            out.println("Domain parsed");
            final PDDLProblem localProblem = new PDDLProblem(problemFile, localDomain.getConstants(),
                    localDomain.getTypes(), localDomain, out, groundingType, sdac, ignoreMetric,
                    new BigDecimal(delta), new BigDecimal(delta));
            if (!localDomain.getProcessesSchema().isEmpty()) {
                localProblem.setDeltaTimeVariable(delta);
            }
            out.println("Problem parsed");
            out.println("Grounding..");
            localProblem.prepareForSearch(aibrPreprocessing, stopAfterGrounding);

            // Copia sicura dei fluenti booleani groundati dall'istanza di problema parsata.
            // Usa getAllFluents() con fallback a PDDLProblem.booleanFluents (statico)
            // se l'API non è disponibile nella versione corrente di ppmajal.
            this.groundedBooleanFluents = new HashSet<>();
            try {
                for (Object f : localProblem.getAllFluents()) {
                    if (f instanceof com.hstairs.ppmajal.conditions.BoolPredicate) {
                        this.groundedBooleanFluents.add((com.hstairs.ppmajal.conditions.BoolPredicate) f);
                    }
                }
            } catch (Exception e) {
                System.err.println("[ENHSP] WARNING: getAllFluents() non disponibile, "
                        + "fallback a PDDLProblem.booleanFluents (statico).");
                this.groundedBooleanFluents = new HashSet<>(PDDLProblem.booleanFluents);
            }
            if (this.groundedBooleanFluents.isEmpty()) {
                System.err.println("[ENHSP] ERROR: Nessun fluente booleano trovato. "
                        + "L'euristica Snowman non funzionera' correttamente.");
            }

            if (stopAfterGrounding) {
                System.exit(1);
            }
            return Pair.of(localDomain, localProblem);
        } catch (Exception ex) {
            Logger.getLogger(ENHSP.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public void parsingDomainAndProblem(String[] args) {
        try {
            overallStart = System.currentTimeMillis();
            Pair<PDDLDomain, PDDLProblem> res = parseDomainProblem(domainFile, problemFile, deltaExecution, System.out);
            domain = res.getKey();
            problem = res.getRight();
            if (pddlPlus) {
                res = parseDomainProblem(domainFile, problemFile, deltaHeuristic, new PrintStream(new OutputStream() {
                    public void write(int b) {
                    }
                }));
                domainHeuristic = res.getKey();
                heuristicProblem = res.getRight();
                copyOfTheProblem = true;
            } else {
                heuristicProblem = problem;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void configurePlanner() {
        if (planner != null) {
            setPlanner();
        }
    }

    // ==================================================================================
    // Preprocessing per il dominio Snowman
    // ==================================================================================

    private List<String> locationNames = new ArrayList<>();
    private java.util.Map<String, Integer> locationIndexMap = new java.util.HashMap<>();

    private int getLocationIndex(String name) {
        Integer idx = locationIndexMap.get(name);
        return idx != null ? idx : -1;
    }

    private int getLocIdIgnoreCase(String token) {
        for (java.util.Map.Entry<String, Integer> entry : locationIndexMap.entrySet()) {
            if (entry.getKey().equalsIgnoreCase(token))
                return entry.getValue();
        }
        return -1;
    }

    private String getBallNameIgnoreCase(String token) {
        for (String b : ballNames) {
            if (b.equalsIgnoreCase(token))
                return b;
        }
        return null;
    }

    /**
     * Estrae dal PDDL i dati necessari per l'euristica Snowman (Grafo Topologico):
     * - Oggetti di tipo "ball" -> nomi delle palle (ballNames)
     * - Oggetti di tipo "location" -> nomi delle location (locationNames)
     * - Costruisce una distanceMatrix usando Floyd-Warshall sul predicato "next"
     * - Identifica i nodi dead-end (Sokoban Invariants) per pruning futuro
     */
    public void preprocessSnowman() {

        // --- Estrai oggetti PDDL di tipo "ball" e "location" ---
        PDDLObjects objects = problem.getProblemObjects();
        for (Object obj : objects.toArray()) {
            PDDLObject pddlObject = (PDDLObject) obj;
            String name = pddlObject.getName();
            String type = pddlObject.getType().getName();

            if (type.equals("ball")) {
                ballNames.add(name);
            } else if (type.equals("location")) {
                locationIndexMap.put(name, locationNames.size());
                locationNames.add(name);
            }
        }

        int N = locationNames.size();

        // --- Inizializza la matrice delle distanze del Grafo ---
        // Usa SnowmanConfigurator.UNREACHABLE come valore sentinella per le coppie
        // non connesse. DEVE coincidere con il valore usato nei check di pruning.
        distanceMatrix = new int[N][N];
        for (int i = 0; i < N; i++) {
            java.util.Arrays.fill(distanceMatrix[i], models.SnowmanConfigurator.UNREACHABLE);
            distanceMatrix[i][i] = 0;
        }

        // --- Sokoban Invariants: Strutture Dati ---
        isDeadEndNode = new boolean[N];
        java.util.Arrays.fill(isDeadEndNode, true);
        java.util.Map<Integer, java.util.Set<String>> incomingDirs = new java.util.HashMap<>();
        java.util.Map<Integer, java.util.Set<String>> outgoingDirs = new java.util.HashMap<>();
        for (int i = 0; i < N; i++) {
            incomingDirs.put(i, new java.util.HashSet<>());
            outgoingDirs.put(i, new java.util.HashSet<>());
        }

        // --- Parser Universale per i fatti "next" (Immune a PPMAJAL) ---
        try {
            String content = java.nio.file.Files.readString(java.nio.file.Path.of(this.problemFile));
            content = content.replaceAll("\\(", " ( ").replaceAll("\\)", " ) ").replaceAll("=", " = ");
            String[] tokens = content.split("\\s+");

            for (int i = 0; i < tokens.length; i++) {
                if (tokens[i].equalsIgnoreCase("next") && i + 3 < tokens.length) {
                    int u = getLocIdIgnoreCase(tokens[i + 1]);
                    int v = getLocIdIgnoreCase(tokens[i + 2]);
                    String dir = tokens[i + 3];

                    if (u != -1 && v != -1) {
                        distanceMatrix[u][v] = 1;
                        outgoingDirs.get(u).add(dir);
                        incomingDirs.get(v).add(dir);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[SnowmanConfig] WARNING: Universal token parser failed for 'next'.");
        }

        // --- 100% Admissible Static Dead-End Check ---
        // Un nodo è un vicolo cieco statico se ha 0 o 1 soli vicini (cul-de-sac).
        // Se la palla entra qui, non può essere spinta oltre (richiederebbe l'azione
        // PULL).
        int deadEndCount = 0;
        for (int i = 0; i < N; i++) {
            int degree = 0;
            for (int j = 0; j < N; j++) {
                if (i != j && distanceMatrix[i][j] == 1) {
                    degree++;
                }
            }
            if (degree <= 1) {
                isDeadEndNode[i] = true;
                deadEndCount++;
            } else {
                isDeadEndNode[i] = false;
            }
        }

        // --- Calcola All-Pairs Shortest Path (Floyd-Warshall O(V^3)) ---
        // --- Floyd-Warshall: Calcolo di tutti i cammini minimi (All-Pairs Shortest
        // Path) ---
        for (int k = 0; k < N; k++) {
            for (int i = 0; i < N; i++) {
                if (distanceMatrix[i][k] >= models.SnowmanConfigurator.UNREACHABLE)
                    continue;
                for (int j = 0; j < N; j++) {
                    if (distanceMatrix[k][j] >= models.SnowmanConfigurator.UNREACHABLE)
                        continue;

                    int dist = distanceMatrix[i][k] + distanceMatrix[k][j];
                    if (dist < distanceMatrix[i][j]) {
                        distanceMatrix[i][j] = dist;
                    }
                }
            }
        }

        targetSnowmen = ballNames.size() / 3;
        if (targetSnowmen == 0 && ballNames.size() > 0) {
            System.err.println("WARNING [Snowman Config]: " + ballNames.size()
                    + " palle trovate, insufficienti per 1 target. Forzatura a targetSnowmen=1.");
            targetSnowmen = 1;
        }

        System.out.println("=== Snowman Topological Preprocessing ===");
        System.out.println("Palle trovate: " + ballNames.size() + " " + ballNames);
        System.out.println("Locations trovate: " + N + " (Graph Nodes)");
        System.out.println("Dead-end nodes: " + deadEndCount + "/" + N);
        System.out.println("Target pupazzi: " + targetSnowmen);
        System.out.println("=========================================");
    }

    public void planning() {
        try {
            printStats();
            setHeuristic();
            do {
                LinkedList<?> sp = search();
                if (sp == null) {
                    return;
                }
                depthLimit = endGValue;
                if (anyTime) {
                    System.out.println(
                            "NEW COST ==================================================================================>"
                                    + depthLimit);
                }
                sp = null;
                System.gc();
            } while (anyTime);
        } catch (Exception ex) {
            Logger.getLogger(ENHSP.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void parseInput(String[] args) {
        Options options = new Options();
        options.addRequiredOption("o", "domain", true, "PDDL domain file");
        options.addRequiredOption("f", "problem", true, "PDDL problem file");
        options.addOption("planner", true,
                "Fast Preconfgured Planner. For available options look into the code. This overrides all other parameters but domain and problem specs.");
        options.addOption("h", true, "heuristic: options (default is AIBR):\n"
                + "aibr, Additive Interval Based relaxation heuristic\n"
                + "hadd, Additive version of subgoaling heuristic\n"
                + "hradd, Additive version of subgoaling heuristic plus redundant constraints\n"
                + "hmax, Hmax for Numeric Planning\n"
                + "hrmax, Hmax for Numeric Planning with redundant constraints\n"
                + "hmrp, heuristic based on MRP extraction\n"
                + "blcost, goal sensitive heuristic (1 to non goal-states, 0 to goal-states)"
                + "blind, full blind heuristic (0 to all states)"
                + "snowman, custom heuristic for snowman problem");
        options.addOption("s", true, "allows to select search strategy (default is WAStar):\n"
                + "gbfs, Greedy Best First Search (f(n) = h(n))\n"
                + "WAStar, WA* (f(n) = g(n) + h_w*h(n))\n"
                + "wa_star_4, WA* (f(n) = g(n) + 4*h(n))\n");
        options.addOption("ties", true, "tie-breaking (default is arbitrary): larger_g, smaller_g, arbitrary");
        options.addOption("dp", "delta_planning", true, "planning decision executionDelta: float");
        options.addOption("de", "delta_execuction", true, "planning execution executionDelta: float");
        options.addOption("dh", "delta_heuristic", true, "planning heuristic executionDelta: float");
        options.addOption("dv", "delta_validation", true, "validation executionDelta: float");
        options.addOption("d", "delta", true,
                "Override other delta_<planning,execuction,validation,heuristic> configurations: float");
        options.addOption("epsilon", true, "epsilon separation: float");
        options.addOption("wg", true, "g-values weight: float");
        options.addOption("wh", true, "h-values weight: float");
        options.addOption("sjr", false, "save state space explored in json file");
        options.addOption("ha", "helpful-actions", true, "activate helpful actions pruning");
        options.addOption("pe", "print-events-plan", false, "activate printing of events");
        options.addOption("ht", "helpful-transitions", true, "activate up-to-macro actions");
        options.addOption("sp", true, "Save plan. Argument is filename");
        options.addOption("pt", false, "print state trajectory (Experimental)");
        options.addOption("dap", false, "Disable Aibr Preprocessing");
        options.addOption("red", "redundant_constraints", true,
                "Choose mechanism for redundant constraints generation among, "
                        + "no, brute and smart. No redundant constraints generation is the default");
        options.addOption("gro", "grounding", true,
                "Activate grounding via internal mechanism, fd or metricff or internal or naive (default is internal)");
        options.addOption("dl", true, "bound on plan-cost: float (Experimental)");
        options.addOption("k", true, "maximal number of subdomains. This works in combination with haddabs: integer");
        options.addOption("anytime", false,
                "Run in anytime modality. Incrementally tries to find an upper bound. Does not stop until the user decides so");
        options.addOption("timeout", true, "Timeout for anytime modality");
        options.addOption("stopgro", false, "Stop After Grounding");
        options.addOption("ival", false, "Internal Validation");
        options.addOption("sdac", false, "Activate State Dependent Action Cost (Very Experimental!)");
        options.addOption("onlyplan", false, "Print only the plan without waiting");

        CommandLineParser parser = new DefaultParser();
        try {
            CommandLine cmd = parser.parse(options, args);
            domainFile = cmd.getOptionValue("o");
            problemFile = cmd.getOptionValue("f");
            planner = cmd.getOptionValue("planner");
            heuristic = cmd.getOptionValue("h");
            if (heuristic == null) {
                heuristic = "hadd";
            }
            searchEngineString = cmd.getOptionValue("s");
            if (searchEngineString == null) {
                searchEngineString = "gbfs";
            }
            tieBreaking = cmd.getOptionValue("ties");
            deltaPlanning = cmd.getOptionValue("dp");
            if (deltaPlanning == null) {
                deltaPlanning = "1.0";
            }
            String optionValue = cmd.getOptionValue("red");
            if (optionValue == null) {
                redundantConstraints = "no";
            } else {
                redundantConstraints = optionValue;
            }
            optionValue = cmd.getOptionValue("gro");
            if (optionValue != null) {
                groundingType = optionValue;
            } else {
                groundingType = "internal";
            }
            internalValidation = cmd.hasOption("ival");

            deltaExecution = cmd.getOptionValue("de");
            if (deltaExecution == null) {
                deltaExecution = "1.0";
            }
            deltaHeuristic = cmd.getOptionValue("dh");
            if (deltaHeuristic == null) {
                deltaHeuristic = "1.0";
            }
            deltaValidation = cmd.getOptionValue("dv");
            if (deltaValidation == null) {
                deltaValidation = "1";
            }
            String temp = cmd.getOptionValue("dl");
            if (temp != null) {
                depthLimit = Float.parseFloat(temp);
            } else {
                depthLimit = Float.NaN;
            }

            String timeOutString = cmd.getOptionValue("timeout");
            if (timeOutString != null) {
                timeOut = Long.parseLong(timeOutString) * 1000;
            } else {
                timeOut = Long.MAX_VALUE;
            }

            String delta = cmd.getOptionValue("delta");
            if (delta != null) {
                deltaHeuristic = delta;
                deltaValidation = delta;
                deltaPlanning = delta;
                deltaExecution = delta;
            }

            String k = cmd.getOptionValue("k");
            if (k != null) {
                numSubdomains = Integer.parseInt(k);
            } else {
                numSubdomains = 2;
            }

            gw = cmd.getOptionValue("wg");
            hw = cmd.getOptionValue("wh");
            saving_json = cmd.hasOption("sjr");
            sdac = cmd.hasOption("sdac");
            helpfulActionsPruning = cmd.getOptionValue("ha") != null && "true".equals(cmd.getOptionValue("ha"));
            printEvents = cmd.hasOption("pe");
            printTrace = cmd.hasOption("pt");
            savePlan = cmd.getOptionValue("sp");
            onlyPlan = cmd.hasOption("onlyplan");
            anyTime = cmd.hasOption("anytime");
            aibrPreprocessing = !cmd.hasOption("dap");
            stopAfterGrounding = cmd.hasOption("stopgro");
            helpfulTransitions = cmd.getOptionValue("ht") != null && "true".equals(cmd.getOptionValue("ht"));
            ignoreMetric = cmd.hasOption("im");
        } catch (ParseException exp) {
            System.err.println("Parsing failed.  Reason: " + exp.getMessage());
            HelpFormatter formatter = new HelpFormatter();
            formatter.printHelp("enhsp", options);
            System.exit(-1);
        }
    }

    public PDDLProblem getProblem() {
        return problem;
    }

    public void printStats() {
        System.out.println("|A|:" + getProblem().getActions().size());
        System.out.println("|P|:" + getProblem().getProcessesSet().size());
        System.out.println("|E|:" + getProblem().getEventsSet().size());
        if (pddlPlus) {
            System.out.println("Delta time heuristic model:" + deltaHeuristic);
            System.out.println("Delta time planning model:" + deltaPlanning);
            System.out.println("Delta time search-execution model:" + deltaExecution);
            System.out.println("Delta time validation model:" + deltaValidation);
        }
    }

    private void setPlanner() {
        helpfulTransitions = false;
        helpfulActionsPruning = false;
        tieBreaking = "arbitrary";
        switch (planner) {
            case "sat-hmrp":
                heuristic = "hmrp";
                searchEngineString = "gbfs";
                tieBreaking = "arbitrary";
                break;
            case "sat-hmrph":
                heuristic = "hmrp";
                helpfulActionsPruning = true;
                searchEngineString = "gbfs";
                tieBreaking = "arbitrary";
                break;
            case "sat-hmrphj":
                heuristic = "hmrp";
                helpfulActionsPruning = true;
                helpfulTransitions = true;
                searchEngineString = "gbfs";
                tieBreaking = "arbitrary";
                break;
            case "sat-hmrpff":
                heuristic = "hmrp";
                helpfulActionsPruning = false;
                redundantConstraints = "brute";
                helpfulTransitions = false;
                searchEngineString = "gbfs";
                tieBreaking = "arbitrary";
                break;
            case "sat-hadd":
                heuristic = "hadd";
                searchEngineString = "gbfs";
                tieBreaking = "smaller_g";
                break;
            case "sat-aibr":
                heuristic = "aibr";
                searchEngineString = "WAStar";
                tieBreaking = "arbitrary";
                break;
            case "sat-hradd":
                heuristic = "hradd";
                searchEngineString = "gbfs";
                tieBreaking = "smaller_g";
                break;
            case "opt-hmax":
                heuristic = "hmax";
                searchEngineString = "WAStar";
                tieBreaking = "larger_g";
                break;
            case "opt-hlm":
                heuristic = "hlm-lp";
                searchEngineString = "WAStar";
                tieBreaking = "larger_g";
                break;
            case "opt-hlmrd":
                heuristic = "hlm-lp";
                redundantConstraints = "brute";
                searchEngineString = "WAStar";
                tieBreaking = "larger_g";
                break;
            case "opt-hrmax":
                heuristic = "hrmax";
                searchEngineString = "WAStar";
                tieBreaking = "larger_g";
                break;
            case "opt-blind":
                heuristic = "blind";
                searchEngineString = "WAStar";
                tieBreaking = "larger_g";
                aibrPreprocessing = false;
                break;
            case "sat-blind":
                heuristic = "blind";
                searchEngineString = "gbfs";
                tieBreaking = "larger_g";
                aibrPreprocessing = false;
                break;
            case "snowman":
                heuristic = "snowman";
                searchEngineString = "gbfs";
                tieBreaking = "smaller_g";
                helpfulActionsPruning = false;
                helpfulTransitions = false;
                break;
            default:
                System.out.println(
                        "! ====== ! Warning: Unknown planner configuration. Going with default: gbfs with hadd ! ====== !");
                heuristic = "hadd";
                searchEngineString = "gbfs";
                tieBreaking = "smaller_g";
                break;
        }
    }

    private void setHeuristic() {
        if (heuristic.equals("snowman")) {
            preprocessSnowman();
            h = new SnowmanHeuristic();
        } else {
            h = PDDLHeuristic.getHeuristic(heuristic, heuristicProblem, redundantConstraints, helpfulActionsPruning,
                    helpfulTransitions);
        }
    }

    private LinkedList<Pair<BigDecimal, Object>> search() throws Exception {

        LinkedList<Pair<BigDecimal, Object>> rawPlan = null;

        final PDDLSearchEngine searchEngine = new PDDLSearchEngine(problem, h);
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                if (saving_json) {
                    searchEngine.searchSpaceHandle.print_json(getProblem().getPddlFileReference() + ".sp_log");
                }
            }
        });
        if (pddlPlus) {
            searchEngine.executionDelta = new BigDecimal(deltaExecution);
            searchEngine.processes = true;
            searchEngine.planningDelta = new BigDecimal(deltaPlanning);
        }

        searchEngine.saveSearchTreeAsJson = saving_json;

        if (tieBreaking != null) {
            switch (tieBreaking) {
                case "smaller_g":
                    searchEngine.tbRule = SearchEngine.TieBreaking.LOWERG;
                    break;
                case "larger_g":
                    searchEngine.tbRule = SearchEngine.TieBreaking.HIGHERG;
                    break;
                default:
                    System.out.println("Wrong setting for break-ties. Arbitrary tie breaking");
                    break;
            }
        } else {
            tieBreaking = "arbitrary";
            searchEngine.tbRule = SearchEngine.TieBreaking.ARBITRARY;
        }

        if (hw != null) {
            searchEngine.setWH(Float.parseFloat(hw));
            System.out.println("w_h set to be " + hw);
        } else {
            searchEngine.setWH(1);
        }

        if (!Float.isNaN(depthLimit)) {
            searchEngine.depthLimit = depthLimit;
            System.out.println("Setting horizon to:" + depthLimit);
        } else {
            searchEngine.depthLimit = Float.POSITIVE_INFINITY;
        }

        System.out.println("Helpful Action Pruning Activated");
        searchEngine.helpfulActionsPruning = helpfulActionsPruning;

        if ("WAStar".equals(searchEngineString)) {
            System.out.println("Running WA-STAR");
            rawPlan = searchEngine.WAStar(getProblem(), timeOut);
        } else if ("wa_star_4".equals(searchEngineString)) {
            System.out.println("Running greedy WA-STAR with hw = 4");
            searchEngine.setWH(4);
            rawPlan = searchEngine.WAStar();
        } else if ("gbfs".equals(searchEngineString)) {
            System.out.println("Running Greedy Best First Search");
            rawPlan = searchEngine.gbfs(getProblem(), timeOut);
        } else if ("gbfs_ha".equals(searchEngineString)) {
            System.out.println("Running Greedy Best First Search with Helpful Actions");
            rawPlan = searchEngine.gbfs(getProblem(), timeOut);
        } else if ("ida".equals(searchEngineString)) {
            System.out.println("Running IDAStar");
            rawPlan = searchEngine.idastar(getProblem(), true);
        } else if ("ucs".equals(searchEngineString)) {
            System.out.println("Running Pure Uniform Cost Search");
            rawPlan = searchEngine.UCS(getProblem());
        } else {
            throw new RuntimeException("Search strategy is not correct");
        }
        endGValue = searchEngine.currentG;

        overallPlanningTime = (System.currentTimeMillis() - overallStart);
        printInfo(rawPlan, searchEngine);
        return rawPlan;
    }

    private void printInfo(LinkedList<Pair<BigDecimal, Object>> sp, PDDLSearchEngine searchEngine)
            throws CloneNotSupportedException {

        PDDLState s = (PDDLState) searchEngine.getLastState();
        if (sp != null) {
            System.out.println("Problem Solved\n");
            System.out.println("Found Plan:");
            printPlan(sp, pddlPlus, s, savePlan);
            System.out.println("\nPlan-Length:" + sp.size());
            planLength = sp.size();
        } else {
            System.out.println("Problem unsolvable");
        }
        if (pddlPlus && sp != null) {
            System.out.println("Elapsed Time: " + s.time);
        }
        System.out.println("Metric (Search):" + searchEngine.currentG);
        System.out.println("Planning Time (msec): " + overallPlanningTime);
        System.out.println("Heuristic Time (msec): " + searchEngine.getHeuristicCpuTime());
        System.out.println("Search Time (msec): " + searchEngine.getOverallSearchTime());
        System.out.println("Expanded Nodes:" + searchEngine.getNodesExpanded());
        System.out.println("States Evaluated:" + searchEngine.getNumberOfEvaluatedStates());
        System.out.println(
                "Fixed constraint violations during search (zero-crossing):" + searchEngine.constraintsViolations);
        System.out.println("Number of Dead-Ends detected:" + searchEngine.deadEndsDetected);
        System.out.println("Number of Duplicates detected:" + searchEngine.duplicatesNumber);
        if (saving_json) {
            searchEngine.searchSpaceHandle.print_json(getProblem().getPddlFileReference() + ".sp_log");
        }
    }

    private void printPlan(LinkedList<Pair<BigDecimal, Object>> plan, boolean temporal, PDDLState par,
            String fileName) {
        float i = 0f;
        Pair<BigDecimal, Object> previous = null;
        List<String> fileContent = new ArrayList<String>();
        boolean startProcess = false;
        int size = plan.size();
        int j = 0;
        for (Pair<BigDecimal, Object> ele : plan) {
            j++;
            if (!temporal) {
                System.out.print(i + ": " + ele.getRight() + "\n");
                if (fileName != null) {
                    TransitionGround t = (TransitionGround) ele.getRight();
                    fileContent.add(t.toString());
                }
                i++;
            } else {
                TransitionGround t = (TransitionGround) ele.getRight();
                if (t.getSemantics() == TransitionGround.Semantics.PROCESS) {
                    if (!startProcess) {
                        previous = ele;
                        startProcess = true;
                    }
                    if (j == size) {
                        if (!onlyPlan) {
                            System.out.println(previous.getLeft() + ": -----waiting---- " + "[" + par.time + "]");
                        }
                    }
                } else {
                    if (t.getSemantics() != TransitionGround.Semantics.EVENT || printEvents) {
                        if (startProcess) {
                            startProcess = false;
                            if (!onlyPlan) {
                                System.out.println(
                                        previous.getLeft() + ": -----waiting---- " + "[" + ele.getLeft() + "]");
                            }
                        }
                        System.out.print(ele.getLeft() + ": " + ele.getRight() + "\n");
                        if (fileName != null) {
                            fileContent.add(ele.getLeft() + ": " + t.toString());
                        }
                    } else {
                        if (j == size) {
                            if (!onlyPlan) {
                                System.out.println(
                                        previous.getLeft() + ": -----waiting---- " + "[" + ele.getLeft() + "]");
                            }
                        }
                    }
                }
            }
        }

        if (fileName != null) {
            try {
                if (temporal) {
                    fileContent.add(par.time + ": @PlanEND ");
                }
                Files.write(Path.of(fileName), fileContent);
            } catch (IOException ex) {
                Logger.getLogger(ENHSP.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    // ==================================================================================
    // Inner class: SnowmanHeuristic (zero-allocation with Trackers)
    // ==================================================================================

    public class SnowmanHeuristic implements SearchHeuristic {

        // --- Tracker classes ---
        private class BallTracker {
            final Ball ballInstance;
            final List<BoolPredLocPair> locationPredicates;
            final NumFluent sizeFluent;

            // Fallback per stati iniziali non correttamente groundati da PPMAJAL
            final int fixedLocId;
            final int fixedSize;

            BallTracker(Ball ballInstance, List<BoolPredLocPair> locationPredicates,
                    NumFluent sizeFluent, int fixedLocId, int fixedSize) {
                this.ballInstance = ballInstance;
                this.locationPredicates = locationPredicates;
                this.sizeFluent = sizeFluent;
                this.fixedLocId = fixedLocId;
                this.fixedSize = fixedSize;
            }
        }

        private class BoolPredLocPair {
            final BoolPredicate predicate;
            final int locId;

            BoolPredLocPair(BoolPredicate pred, int locId) {
                this.predicate = pred;
                this.locId = locId;
            }
        }

        private class CellTracker {
            // snowPredicate è null se il grounder PPMAJAL non ha incluso questo fluente.
            // In quel caso la cella NON viene tracciata (neve non vista = neve assente
            // per l'euristica → admissible: underestimate).
            // NOTA: isPermanent è stato rimosso perché la neve viene consumata quando
            // una palla ci passa sopra — marcarla permanente causerebbe inadmissibility.
            BoolPredicate snowPredicate;
            final int locId;

            CellTracker(int locId) {
                this.locId = locId;
            }
        }

        private class CharacterTracker {
            final BoolPredicate predicate;
            final int locId;

            CharacterTracker(BoolPredicate pred, int locId) {
                this.predicate = pred;
                this.locId = locId;
            }
        }

        // --- Pre-instantiated state ---
        private final List<BallTracker> ballTrackers;
        private final List<CellTracker> cellTrackers;
        private final List<CharacterTracker> characterTrackers;
        private final List<Ball> preInstantiatedBalls;
        private final SnowmanConfigurator configurator;
        private final boolean allSnowTracked;

        // GC Zero-Allocation Reusable Data Structures
        private final List<Ball> activeBallsList;
        private final List<Ball> remainingBallsList;
        private final int[] size1Count;
        private final int[] size2Count;
        private final int[] size3Count;
        private final boolean[] currentSnow;
        private final boolean[] initialSnowArray;
        private final int[] sizesBuffer; // pre-allocato per snow budget check
        private final int fixedCharLoc; // posizione iniziale del personaggio come fallback

        // Ball-state caching: evita di ricalcolare h_balls quando solo il personaggio
        // si sposta
        private long cachedBallFingerprint;
        private long cachedSnowFingerprint;
        private double cachedHBalls;
        private int cachedRemainingTargets;

        // Helpful transitions: pre-allocata per evitare allocazioni nella hot path
        private Collection<TransitionGround> cachedHelpfulTransitions;
        private final List<TransitionGround> helpfulTransitionBuffer;

        @SuppressWarnings("unchecked")
        public SnowmanHeuristic() {
            ballTrackers = new ArrayList<>();
            cellTrackers = new ArrayList<>();
            characterTrackers = new ArrayList<>();
            preInstantiatedBalls = new ArrayList<>();

            int N = locationNames.size();
            currentSnow = new boolean[N];

            // --- Indicizza i NumFluent per ball_size ---
            Set<String> ballNamesSet = new HashSet<>(ballNames);
            Map<String, NumFluent> sizeFluentMap = new HashMap<>();
            List<NumFluent> numFluents = problem.getNumFluents();
            for (NumFluent nf : numFluents) {
                if (nf.getName().equals("ball_size")) {
                    String ballName = ((PDDLObject) nf.getTerms().get(0)).getName();
                    if (ballNamesSet.contains(ballName)) {
                        sizeFluentMap.put(ballName, nf);
                    }
                }
            }

            // --- Indicizza i BoolPredicate per ball_at, character_at, snow ---
            Map<String, List<BoolPredLocPair>> ballAtMap = new HashMap<>();
            for (String bn : ballNames)
                ballAtMap.put(bn, new ArrayList<>());

            Map<String, CellTracker> cellTrackerMap = new HashMap<>();

            for (BoolPredicate bf : ENHSP.this.groundedBooleanFluents) {
                String pName = bf.getName();
                List<PDDLObject> terms = bf.getTerms();

                if (pName.equals("ball_at")) {
                    String bName = ((PDDLObject) terms.get(0)).getName();
                    String lName = ((PDDLObject) terms.get(1)).getName();
                    if (ballNames.contains(bName)) {
                        int locId = getLocationIndex(lName);
                        if (locId != -1) {
                            ballAtMap.get(bName).add(new BoolPredLocPair(bf, locId));
                        }
                    }
                } else if (pName.equals("character_at")) {
                    String lName = ((PDDLObject) terms.get(0)).getName();
                    int locId = getLocationIndex(lName);
                    if (locId != -1) {
                        characterTrackers.add(new CharacterTracker(bf, locId));
                    }
                } else if (pName.equals("snow")) {
                    String lName = ((PDDLObject) terms.get(0)).getName();
                    int locId = getLocationIndex(lName);
                    if (locId != -1) {
                        CellTracker ct = cellTrackerMap.get(lName);
                        if (ct == null) {
                            ct = new CellTracker(locId);
                            cellTrackerMap.put(lName, ct);
                        }
                        ct.snowPredicate = bf;
                    }
                }
            }

            cellTrackers.addAll(cellTrackerMap.values());

            // --- Parser naïve PDDL per stato iniziale ---
            // Fallback per ottenere posizioni e taglie iniziali delle palle quando
            // il grounder PPMAJAL non le include correttamente nei fluenti groundati.
            // NOTA: questo parser è semplice e funziona solo per PDDL ben formattati
            // con una predicato per riga. Non sostituisce il grounder per gli stati
            // dinamici.
            // Strutture di appoggio
            // --- Parser Sicuro PDDL tramite API interne (PPMAJAL) e Fallback ---
            // --- Parser Universale Token-Based (Immune alla formattazione) ---
            // --- Parser Universale Token-Based (Immune alla formattazione) ---
            Map<String, Integer> initialBallPositions = new HashMap<>();
            Map<String, Integer> initialBallSizes = new HashMap<>();
            int initialCharPos = -1;
            Set<Integer> initialSnowPositions = new HashSet<>();

            try {
                String content = java.nio.file.Files.readString(java.nio.file.Path.of(ENHSP.this.problemFile));
                content = content.replaceAll("\\(", " ( ").replaceAll("\\)", " ) ").replaceAll("=", " = ");
                String[] tokens = content.split("\\s+");
                for (int i = 0; i < tokens.length; i++) {
                    if (tokens[i].equalsIgnoreCase("snow") && i + 1 < tokens.length) {
                        int locId = getLocIdIgnoreCase(tokens[i + 1]);
                        if (locId != -1)
                            initialSnowPositions.add(locId);
                    } else if (tokens[i].equalsIgnoreCase("ball_size") && i + 1 < tokens.length) {
                        String bName = getBallNameIgnoreCase(tokens[i + 1]);
                        if (bName != null) {
                            for (int j = i + 2; j <= i + 4 && j < tokens.length; j++) {
                                try {
                                    initialBallSizes.put(bName, Integer.parseInt(tokens[j]));
                                    break;
                                } catch (Exception ignored) {
                                }
                            }
                        }
                    } else if (tokens[i].equalsIgnoreCase("ball_at") && i + 2 < tokens.length) {
                        String bName = getBallNameIgnoreCase(tokens[i + 1]);
                        int locId = getLocIdIgnoreCase(tokens[i + 2]);
                        if (bName != null && locId != -1)
                            initialBallPositions.put(bName, locId);
                    } else if (tokens[i].equalsIgnoreCase("character_at") && i + 1 < tokens.length) {
                        initialCharPos = getLocIdIgnoreCase(tokens[i + 1]);
                    }
                }
            } catch (Exception e) {
                System.err.println("[SnowmanHeuristic] WARNING: Universal token parser failed.");
            }

            // --- Override opzionale con API PPMAJAL (se disponibili) ---
            Iterable<?> initPredicates = problem.getPredicatesInvolvedInInit();
            if (initPredicates != null) {
                for (Object obj : initPredicates) {
                    if (obj instanceof BoolPredicate) {
                        BoolPredicate bp = (BoolPredicate) obj;
                        String pName = bp.getName();
                        List<PDDLObject> terms = bp.getTerms();

                        if (pName.equals("ball_at") && terms.size() >= 2) {
                            int locId = getLocationIndex(terms.get(1).getName());
                            if (locId != -1)
                                initialBallPositions.put(terms.get(0).getName(), locId);
                        } else if (pName.equals("character_at") && terms.size() >= 1) {
                            initialCharPos = getLocationIndex(terms.get(0).getName());
                        } else if (pName.equals("snow") && terms.size() >= 1) {
                            int locId = getLocationIndex(terms.get(0).getName());
                            if (locId != -1)
                                initialSnowPositions.add(locId);
                        }
                    }
                }
            }

            this.fixedCharLoc = initialCharPos;

            // 3. Popolamento array di fallback per la neve (FINALMENTE CORRETTO)
            initialSnowArray = new boolean[locationNames.size()];
            for (int locId : initialSnowPositions) {
                if (locId >= 0 && locId < locationNames.size()) {
                    initialSnowArray[locId] = true;
                }
            }

            // Verifica quante snow cells hanno un snowPredicate nel grounder
            long trackedSnowCount = cellTrackers.stream()
                    .filter(ct -> ct.snowPredicate != null)
                    .count();
            this.allSnowTracked = (trackedSnowCount >= initialSnowPositions.size());
            System.out.println("[SnowmanHeuristic] Snow cells in PDDL: " + initialSnowPositions.size()
                    + ", tracked by grounder: " + trackedSnowCount
                    + (allSnowTracked ? " [FULL COVERAGE]" : " [PARTIAL - snow budget check disabled]"));

            // --- Crea BallTracker con intId 0..N-1 ---
            int intId = 0;
            for (String bName : ballNames) {
                Ball ball = new Ball(bName, intId, 1, -1);
                preInstantiatedBalls.add(ball);
                int defaultLoc = initialBallPositions.getOrDefault(bName, -1);
                int defaultSize = initialBallSizes.getOrDefault(bName, 1);
                ballTrackers.add(new BallTracker(
                        ball, ballAtMap.get(bName), sizeFluentMap.get(bName), defaultLoc, defaultSize));
                intId++;
            }

            // --- Instanzia il configurator con i grouping pre-computati ---
            configurator = new SnowmanConfigurator(locationNames.size(),
                    preInstantiatedBalls, targetSnowmen, distanceMatrix);

            // GC Zero-Allocation pre-assignments
            int numBalls = preInstantiatedBalls.size();
            activeBallsList = new ArrayList<>(numBalls);
            remainingBallsList = new ArrayList<>(numBalls);
            sizesBuffer = new int[numBalls];
            int locs = locationNames.size();
            size1Count = new int[locs];
            size2Count = new int[locs];
            size3Count = new int[locs];

            cachedBallFingerprint = 0L;
            cachedHBalls = 0.0;
            cachedRemainingTargets = 0;
            cachedSnowFingerprint = 0L;

            // Pre-allocazione buffer per helpful transitions (zero-allocation nella hot
            // path)
            helpfulTransitionBuffer = new ArrayList<>(256);
            cachedHelpfulTransitions = null;

            System.out.println("SnowmanHeuristic initialized: "
                    + ballTrackers.size() + " ball trackers, "
                    + cellTrackers.size() + " cell trackers, "
                    + characterTrackers.size() + " character trackers");
        }

        @Override
        public float computeEstimate(State state) {
            try {

                // --- 1. Aggiorna neve ---
                // Celle senza snowPredicate (grounder miss) non vengono tracciate:
                // meglio sottostimare la neve disponibile (ammissibile) che sovrastimarla.
                java.util.Arrays.fill(currentSnow, false);
                for (CellTracker ct : cellTrackers) {
                    if (ct.snowPredicate != null && ct.snowPredicate.isSatisfied(state)) {
                        currentSnow[ct.locId] = true;
                    }
                }
                // Fallback: se PPMAJAL tratta snow come predicato statico, isSatisfied()
                // restituisce
                // sempre false e numActiveSnowCells sarebbe 0. In quel caso usiamo la neve
                // iniziale
                // (ammissibile: il problema rilassato con neve iniziale ha h* ≤ h* reale).
                boolean anySnow = false;
                for (boolean s : currentSnow) {
                    if (s) {
                        anySnow = true;
                        break;
                    }
                }
                if (!anySnow) {
                    System.arraycopy(initialSnowArray, 0, currentSnow, 0, currentSnow.length);
                }
                configurator.updateEnvironment(currentSnow);

                // --- 2. Aggiorna palle via tracker (Zero-Allocation) ---
                activeBallsList.clear();
                remainingBallsList.clear();
                java.util.Arrays.fill(size1Count, 0);
                java.util.Arrays.fill(size2Count, 0);
                java.util.Arrays.fill(size3Count, 0);

                for (BallTracker bt : ballTrackers) {
                    int s = bt.fixedSize;
                    if (bt.sizeFluent != null) {
                        Double val = bt.sizeFluent.eval(state);
                        // IGNORA i valori 0.0 di default del grounder. Le palle hanno sempre size >= 1
                        if (val != null && val.intValue() > 0) {
                            s = val.intValue();
                        }
                    }
                    int locId = bt.fixedLocId;
                    for (BoolPredLocPair lp : bt.locationPredicates) {
                        if (lp.predicate.isSatisfied(state)) {
                            locId = lp.locId;
                            break;
                        }
                    }
                    if (locId >= 0) {
                        int ballIntId = bt.ballInstance.getIntId();
                        Ball b = preInstantiatedBalls.get(ballIntId);
                        b.setSize(s);
                        b.setLocId(locId);
                        activeBallsList.add(b);

                        if (s == 1)
                            size1Count[locId]++;
                        else if (s == 2)
                            size2Count[locId]++;
                        else if (s == 3)
                            size3Count[locId]++;
                    }
                }

                // --- 3. Dead-end check: palle insufficienti per i target rimanenti ---
                if (activeBallsList.size() < 3 * targetSnowmen)
                    return Float.POSITIVE_INFINITY;

                // --- 3.1 Filtra palle già parte di un pupazzo completato ---
                // Un pupazzo è completato se ci sono size=1, size=2, size=3 tutte alla stessa
                // loc.
                int completedSnowmen = 0;
                for (int loc = 0; loc < size1Count.length; loc++) {
                    int full = Math.min(size1Count[loc], Math.min(size2Count[loc], size3Count[loc]));
                    completedSnowmen += full;
                    size1Count[loc] -= full;
                    size2Count[loc] -= full;
                    size3Count[loc] -= full;
                }

                for (Ball b : activeBallsList) {
                    int loc = b.getLocId();
                    int s = b.getSize();
                    if (s == 1 && size1Count[loc] > 0) {
                        size1Count[loc]--;
                        remainingBallsList.add(b);
                    } else if (s == 2 && size2Count[loc] > 0) {
                        size2Count[loc]--;
                        remainingBallsList.add(b);
                    } else if (s == 3 && size3Count[loc] > 0) {
                        size3Count[loc]--;
                        remainingBallsList.add(b);
                    }
                }

                for (Ball b : remainingBallsList) {
                    int bLoc = b.getLocId();
                    // isDeadEndNode appartiene alla classe ENHSP esterna
                    if (ENHSP.this.isDeadEndNode[bLoc] == true) {
                        // Se non c'è neve qui, e la palla deve crescere, è morta!
                        if (currentSnow[bLoc] == false && b.getSize() < 3) {
                            return Float.POSITIVE_INFINITY;
                        }
                    }
                }

                int remainingTargets = targetSnowmen - completedSnowmen;
                if (remainingTargets < 0) {
                    System.err.println("[SnowmanHeuristic] WARNING: completedSnowmen ("
                            + completedSnowmen + ") > targetSnowmen (" + targetSnowmen
                            + "). Stato inconsistente nel parsing.");
                    remainingTargets = 0;
                }

                // --- 4. Risoluzione Configurator ---
                double h_balls = 0.0;
                if (remainingTargets > 0) {

                    // --- 4.1 Snow Budget Dead-End Check ---
                    // Calcola il minimo totale di neve necessaria assegnando ottimamente i ruoli:
                    // le palle più grandi prendono i ruoli più alti (minimizzando la crescita).
                    // Ordina per taglia decrescente usando sizesBuffer pre-allocato.
                    int nBalls = remainingBallsList.size();
                    for (int i = 0; i < nBalls; i++) {
                        sizesBuffer[i] = remainingBallsList.get(i).getSize();
                    }
                    java.util.Arrays.sort(sizesBuffer, 0, nBalls);
                    // Inversione in-place per ordine decrescente
                    for (int lo = 0, hi = nBalls - 1; lo < hi; lo++, hi--) {
                        int tmp = sizesBuffer[lo];
                        sizesBuffer[lo] = sizesBuffer[hi];
                        sizesBuffer[hi] = tmp;
                    }
                    int totalMissingSnow = 0;
                    int rt = remainingTargets;
                    for (int i = 0; i < rt && i < nBalls; i++) {
                        totalMissingSnow += Math.max(0, 3 - sizesBuffer[i]);
                    }
                    for (int i = rt; i < 2 * rt && i < nBalls; i++) {
                        totalMissingSnow += Math.max(0, 2 - sizesBuffer[i]);
                    }
                    // role=1 non richiede neve aggiuntiva (size >= 1 sempre)

                    if (allSnowTracked && totalMissingSnow > configurator.getNumActiveSnowCells()) {
                        return Float.POSITIVE_INFINITY; // Dead-end: neve insufficiente
                    }

                    // --- 4.2 Ball-State Caching ---
                    // Se palle e neve non sono cambiate dall'ultima call, riusa h_balls cached.
                    // Il fingerprint della neve è O(1) da getSnowFingerprint() (calcolato in
                    // updateEnvironment).
                    long ballFP = 0;
                    for (Ball b : remainingBallsList) {
                        ballFP = ballFP * 131 + b.getLocId() * 7 + b.getSize();
                    }
                    long snowFP = configurator.getSnowFingerprint();

                    if (ballFP == cachedBallFingerprint
                            && snowFP == cachedSnowFingerprint
                            && remainingTargets == cachedRemainingTargets
                            && cachedHBalls < models.SnowmanConfigurator.UNREACHABLE) {
                        h_balls = cachedHBalls;
                    } else {
                        h_balls = configurator.getBestScore(remainingBallsList, remainingTargets);
                        cachedBallFingerprint = ballFP;
                        cachedSnowFingerprint = snowFP;
                        cachedHBalls = h_balls;
                        cachedRemainingTargets = remainingTargets;
                    }

                    if (h_balls >= models.SnowmanConfigurator.UNREACHABLE)
                        return Float.POSITIVE_INFINITY;
                }

                // --- 5. Tie-Breaking: Push-Position del Personaggio ---
                // move_character ha costo 0 nel dominio PDDL, quindi h_char NON
                // contribuisce al lower bound ammissibile. Viene usata come TIE-BREAKER
                // epsilon (0.001): tra due stati con lo stesso h_balls, espandiamo prima
                // quello con il personaggio più vicino a una push-position valida.
                // epsilon < 1.0 garantisce che il tie-breaker non alteri mai l'ordine
                // tra valori h_balls interi distinti.
                double h_char = 0.0;
                int charLocId = this.fixedCharLoc;
                for (CharacterTracker qt : characterTrackers) {
                    if (qt.predicate.isSatisfied(state)) {
                        charLocId = qt.locId;
                        break;
                    }
                }
                if (charLocId >= 0 && !remainingBallsList.isEmpty()) {
                    double minDist = Double.POSITIVE_INFINITY;
                    for (Ball b : remainingBallsList) {
                        int bLoc = b.getLocId();
                        for (int n = 0; n < distanceMatrix[bLoc].length; n++) {
                            if (distanceMatrix[bLoc][n] == 1) { // n è una push-position di bLoc
                                double d = distanceMatrix[charLocId][n];
                                if (d < minDist)
                                    minDist = d;
                            }
                        }
                    }
                    if (minDist < models.SnowmanConfigurator.UNREACHABLE) {
                        h_char = minDist * 0.001;
                    }
                }

                double totalH = h_balls + h_char;

                // --- 6. Helpful Transitions (caching per getTransitions) ---
                if (helpfulTransitions && totalH < Float.POSITIVE_INFINITY) {
                    cachedHelpfulTransitions = computeHelpfulTransitions(state);
                } else {
                    cachedHelpfulTransitions = null;
                }

                return (float) Math.max(0.0, totalH);

            } catch (Exception e) {
                System.err.println("[SnowmanHeuristic] EXCEPTION in computeEstimate: " + e.getMessage());
                e.printStackTrace(System.err);
                return Float.POSITIVE_INFINITY;
            }
        }

        /**
         * Filtra le transizioni mantenendo solo quelle "helpful":
         * - move_character: solo quelle che riducono la distanza verso almeno una
         * push-position
         * - altre azioni: mantenute tutte
         * Usa helpfulTransitionBuffer pre-allocato per evitare allocazioni nella hot
         * path.
         */
        private Collection<TransitionGround> computeHelpfulTransitions(State state) {
            // Pruning topologico statico disabilitato per mantenere la completezza di A* in
            // presenza di ostacoli dinamici.
            // Ci affidiamo unicamente all'epsilon tie-breaking per guidare la ricerca.
            return problem.getTransitions();
        }

        @Override
        public Collection<TransitionGround> getAllTransitions() {
            return problem.getTransitions();
        }

        @Override
        public Object[] getTransitions(boolean arg0) {
            Collection<TransitionGround> x;
            if (helpfulTransitions && cachedHelpfulTransitions != null) {
                x = cachedHelpfulTransitions;
            } else {
                x = problem.getTransitions();
            }
            return x.toArray(new TransitionGround[x.size()]);
        }
    }

}
