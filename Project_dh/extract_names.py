import os
import sys

def extract_names(target_dir):
    if not os.path.exists(target_dir):
        print(f"Errore: La cartella '{target_dir}' non esiste.")
        sys.exit(1)
        
    for root, dirs, files in os.walk(target_dir):
        names = []
        for file in files:
            if file.endswith("_problem.pddl"):
                # Rimuove il suffisso per ottenere solo il nome
                name = file.replace("_problem.pddl", "")
                names.append(name)
        
        # Se ha trovato dei file validi in questa cartella
        if names:
            names.sort() # Ordina i nomi alfabeticamente
            output_file = os.path.join(root, "nomi.txt")
            
            # Salva la lista nel file .txt
            with open(output_file, 'w', encoding='utf-8') as f:
                for name in names:
                    f.write(f"{name}\n")
            
            print(f"Salvati {len(names)} nomi in {output_file}")

if __name__ == "__main__":
    # Controlla che sia stato passato il percorso come argomento
    if len(sys.argv) != 2:
        print("Uso: python extract_names.py <percorso_cartella>")
        sys.exit(1)
        
    target_folder = sys.argv[1]
    extract_names(target_folder)
