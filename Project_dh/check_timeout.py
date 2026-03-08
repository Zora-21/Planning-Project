import os
import sys

def check_timeouts(path_list):
    unsolved_files = []
    solved_count = 0
    timeout_count = 0
    
    # Se viene passata una stringa singola, la trasformiamo in lista
    if isinstance(path_list, str):
        path_list = [path_list]

    for path in path_list:
        # Se il path è una cartella, prendiamo tutti i file .txt all'interno
        if os.path.isdir(path):
            files_to_check = [os.path.join(path, f) for f in os.listdir(path) if f.endswith(".txt")]
        else:
            files_to_check = [path]

        for file_path in files_to_check:
            if not os.path.exists(file_path):
                print(f"Avviso: File non trovato {file_path}")
                continue
                
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    if "TIMEOUT" in content:
                        timeout_count += 1
                        unsolved_files.append(file_path)
                    else:
                        # Assumiamo che se non c'è TIMEOUT e il file non è vuoto, sia risolto
                        if content.strip():
                            solved_count += 1
            except Exception as e:
                print(f"Errore nella lettura di {file_path}: {e}")

    # Revisione finale e salvataggio
    print("\n" + "="*30)
    print(f"STATISTICHE ESECUZIONE:")
    print(f"Piani Risolti:    {solved_count}")
    print(f"Piani in TIMEOUT: {timeout_count}")
    print("="*30)

    if unsolved_files:
        output_name = "piani_non_risolti.txt"
        with open(output_name, 'w', encoding='utf-8') as out_f:
            for f in unsolved_files:
                out_f.write(f"{f}\n")
        print(f"\nLista dei file non risolti salvata in: {output_name}")
    else:
        print("\nOttimo! Tutti i piani sono stati risolti correttamente.")

if __name__ == "__main__":
    # Esempio di utilizzo: python check_timeout.py /path/cartella1 /path/cartella2
    if len(sys.argv) < 2:
        print("Uso: python check_timeout.py <path_o_cartella1> <path_o_cartella2> ...")
        sys.exit(1)
        
    paths = sys.argv[1:]
    check_timeouts(paths)
