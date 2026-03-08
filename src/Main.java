
/* 
 * Copyright (C) 2015-2017, Enrico Scala, contact: enricos83@gmail.com
 * Modified for Snowman Extension, 2026
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

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import planners.ENHSP;

public class Main {

    /*
     * Per eseguire da linea di comando con argomenti arbitrari:
     * public static void main(String[] args) throws Exception {
     * ENHSP p = new ENHSP(false);
     * p.parseInput(args);
     * p.configurePlanner();
     * p.parsingDomainAndProblem(args);
     * p.planning();
     * }
     */

    public static void main(String[] args) throws Exception {
        if (args.length > 0) {
            ENHSP p = new ENHSP(false);
            p.parseInput(args);
            p.configurePlanner();
            p.parsingDomainAndProblem(args);
            p.planning();
        } else {
            String[] inputNames = {
                    // "martingala",
                    "martingala2"
            }; // Aggiungi qui tutti i nomi che ti servono

            String basePath = "/Users/matteo/Documents/Planning-Project/Project/1-snowman/Goal/";
            String domain = basePath + "Domain_one_goal.pddl";

            for (String name : inputNames) {
                System.out.println("--- Inizio elaborazione per: " + name + " ---");

                String problem = basePath + name + "_problem.pddl";
                String outputFile = basePath + name + "_plan.txt";

                if (!new File(problem).exists()) {
                    System.out.println("Errore: File del problema non trovato: " + problem + ". Salto al prossimo.");
                    System.out.println("-----------------------------------\n");
                    continue;
                }

                PrintStream originalOut = System.out;
                try {
                    // Salva l'output nel file di piano corrispondente
                    PrintStream fileOut = new PrintStream(new FileOutputStream(outputFile));
                    System.setOut(fileOut);

                    String[] a = { "-o", domain, "-f", problem, "-planner", "snowman" };
                    ENHSP p = new ENHSP(false);
                    p.parseInput(a);
                    p.configurePlanner();
                    p.parsingDomainAndProblem(a);
                    p.planning();

                    // Ripristina l'output originale
                    System.setOut(originalOut);
                    fileOut.close();

                    System.out.println("Output salvato con successo in " + outputFile);
                } catch (Exception e) {
                    System.setOut(originalOut);
                    System.out.println("Si è verificato un errore imprevisto durante l'elaborazione di " + name + ": "
                            + e.getMessage());
                    e.printStackTrace();
                }

                System.out.println("--- Elaborazione per " + name + " completata --- \n");
            }
        }
    }

}
