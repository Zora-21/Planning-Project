import subprocess
import os

# Elenco dei nomi da elaborare
input_names = [
"carlasta",
"martingala",
"kate",
#"priscilla",
#"unused_1",
"carlasta2",
"alice",
"martingala2",
"julian",
#"david",
#"chris",
#"sally",
#"louise",
#"helen",
#"lucy",
"joan",
#"tanya",
#"adam"
"kevin",
#"lydia",
#"unused_2",
#"sarah",
#"lauren",
"chrisgur",
"willow"
]  # Aggiungi qui tutti i nomi che ti servono

# Il file di dominio rimane lo stesso per tutti
domain_file = "Domain_count.pddl"

# Itera su ogni nome nell'elenco
for name in input_names:
    print(f"--- Inizio elaborazione per: {name} ---")

    # Costruisce dinamicamente i nomi dei file di problema e di output
    problem_file = f"{name}_problem.pddl"
    output_file = f"{name}_plan.txt"

    # Controlla se il file del problema esiste prima di eseguire il comando
    if not os.path.exists(problem_file):
        print(f"Errore: File del problema non trovato: {problem_file}. Salto al prossimo.")
        print("-----------------------------------\n")
        continue

    # Comando per eseguire il JAR con i file specifici per il nome corrente
    command = [
        "java",
        "-jar",
        "enhsp-20.jar",
        "-o", domain_file,
        "-f", problem_file
    ]

    try:
        # Esegue il JAR e cattura l'output, con un timeout di 300 secondi (5 minuti)
        process = subprocess.run(
            command,
            capture_output=True,
            text=True,
            check=True,  # Lancia un'eccezione se il processo restituisce un codice di errore
            timeout=1200  # Imposta il timeout a 5 minuti
        )

        # Salva l'output nel file di piano corrispondente
        with open(output_file, 'w') as f:
            f.write(process.stdout)

        print(f"Output salvato con successo in {output_file}")

    except subprocess.TimeoutExpired:
        # Gestisce il caso in cui il processo superi il tempo limite
        print(f"Timeout: L'elaborazione per {name} ha superato i 5 minuti. Salto al prossimo.")
    except subprocess.CalledProcessError as e:
        print(f"Errore durante l'esecuzione di enhsp-20.jar per {name}:")
        # Stampa l'errore standard per aiutare nel debug
        print(e.stderr)
    except FileNotFoundError:
        # Questo errore si verifica se 'java' non è nel PATH o il .jar non è presente
        print("Errore: Il comando 'java' non è stato trovato o 'enhsp-20.jar' non è nella directory corrente.")
        # Interrompe il ciclo se il JAR non può essere eseguito
        break
    except Exception as e:
        print(f"Si è verificato un errore imprevisto durante l'elaborazione di {name}: {str(e)}")

    print(f"--- Elaborazione per {name} completata --- \n")
