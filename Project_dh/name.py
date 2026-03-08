import os

def extract_names_from_plans(directory_path):
    """
    Estrae i nomi dai file nel formato '{nome}_plan.txt' all'interno di una cartella specificata.

    Args:
        directory_path (str): Il percorso della cartella da scansionare.

    Returns:
        list: Una lista di stringhe contenente i nomi estratti.
              Restituisce una lista vuota se la cartella non esiste o non contiene file corrispondenti.
    """
    names = []
    # Controlla se il percorso fornito è una directory valida
    if not os.path.isdir(directory_path):
        print(f"Errore: La cartella '{directory_path}' non esiste o non è una directory valida.")
        return names

    # Itera su tutti i file e le sottocartelle nella directory specificata
    for filename in os.listdir(directory_path):
        # Costruisci il percorso completo del file
        file_path = os.path.join(directory_path, filename)

        # Controlla se è un file e se il nome corrisponde al pattern desiderato
        if os.path.isfile(file_path) and filename.endswith("_plan.txt"):
            # Rimuovi l'estensione '_plan.txt' per ottenere il nome
            name = filename.replace("_plan.txt", "")
            names.append(name)
    return names

# --- Esempio di utilizzo ---
if __name__ == "__main__":
    # Crea una cartella di esempio e alcuni file per testare lo script
    directory = "/Users/matteo/Documents/Planning-Project/data"
    os.makedirs(directory, exist_ok=True) # Crea la cartella se non esiste

    folder_to_scan = directory

    # Chiama la funzione per estrarre i nomi
    extracted_names = extract_names_from_plans(folder_to_scan)

    if extracted_names:
        print("\nNomi estratti dai file '_plan.txt':")
        print(extracted_names) # Stampa la lista direttamente
    else:
        print("\nNessun nome estratto o cartella non valida.")

    # Puoi anche pulire la cartella di test dopo l'esecuzione
    # import shutil
    # shutil.rmtree(test_directory)
    # print(f"\nCartella di test '{test_directory}' rimossa.")
