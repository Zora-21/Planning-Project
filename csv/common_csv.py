import pandas as pd
import os
import glob
from pathlib import Path

def trova_piani_comuni(cartella_input, file_output="piani_comuni.csv"):
    """
    Trova i piani comuni tra tutti i file CSV nel formato plan_{tipo}.csv
    e salva il risultato con i nomi dei file modificati aggiungendo _{tipo}
    
    Args:
        cartella_input (str): Percorso della cartella contenente i CSV
        file_output (str): Nome del file di output
    """
    
    # Trova tutti i file che seguono il pattern plan_{tipo}.csv
    pattern = os.path.join(cartella_input, "plan_*.csv")
    file_csv = glob.glob(pattern)
    
    if not file_csv:
        print(f"Nessun file trovato con il pattern 'plan_*.csv' nella cartella {cartella_input}")
        return
    
    print(f"Trovati {len(file_csv)} file CSV:")
    for file in file_csv:
        print(f"  - {os.path.basename(file)}")
    
    # Dizionario per memorizzare i dataframe e i tipi
    dataframes = {}
    tipi = {}
    
    # Carica tutti i CSV
    for file_path in file_csv:
        nome_file = os.path.basename(file_path)
        # Estrae il tipo dal nome del file (es: plan_premium.csv -> premium)
        tipo = nome_file.replace("plan_", "").replace(".csv", "")
        tipi[file_path] = tipo
        
        try:
            df = pd.read_csv(file_path)
            if 'filename' not in df.columns:
                print(f"Attenzione: il file {nome_file} non contiene la colonna 'filename'")
                continue
            dataframes[file_path] = df
            print(f"Caricato {nome_file} con {len(df)} righe")
        except Exception as e:
            print(f"Errore nel caricamento di {nome_file}: {e}")
    
    if len(dataframes) < 2:
        print("Servono almeno 2 file CSV validi per trovare i piani comuni")
        return
    
    # Trova i piani comuni confrontando i valori nella colonna 'filename'
    file_paths = list(dataframes.keys())
    
    # Inizia con i piani del primo file
    piani_comuni = set(dataframes[file_paths[0]]['filename'].unique())
    print(f"Piani iniziali dal primo file: {len(piani_comuni)}")
    
    # Trova l'intersezione con tutti gli altri file
    for file_path in file_paths[1:]:
        piani_file = set(dataframes[file_path]['filename'].unique())
        piani_comuni = piani_comuni.intersection(piani_file)
        print(f"Piani comuni dopo confronto con {os.path.basename(file_path)}: {len(piani_comuni)}")
    
    if not piani_comuni:
        print("Nessun piano comune trovato tra tutti i file")
        return
    
    print(f"\nTrovati {len(piani_comuni)} piani comuni")
    
    # Crea il dataframe finale con tutti i piani comuni
    risultato_finale = []
    
    for file_path in file_paths:
        df = dataframes[file_path]
        tipo = tipi[file_path]
        
        # Filtra solo i piani comuni
        df_comuni = df[df['filename'].isin(piani_comuni)].copy()
        
        # Modifica la colonna filename aggiungendo _{tipo}
        df_comuni['filename'] = df_comuni['filename'] + f"_{tipo}"
        
        risultato_finale.append(df_comuni)
        print(f"Aggiunti {len(df_comuni)} record dal file {os.path.basename(file_path)}")
    
    # Combina tutti i dataframe
    df_finale = pd.concat(risultato_finale, ignore_index=True)
    
    # Salva il risultato
    percorso_output = os.path.join(cartella_input, file_output)
    df_finale.to_csv(percorso_output, index=False)
    
    print(f"\nRisultato salvato in: {percorso_output}")
    print(f"Totale righe nel file finale: {len(df_finale)}")
    print("\nEsempi di nomi modificati:")
    for filename in sorted(df_finale['filename'].unique())[:5]:
        print(f"  - {filename}")
    
    return df_finale

def main():
    """
    Funzione principale - modifica il percorso della cartella qui sotto
    """
    # MODIFICA QUESTO PERCORSO CON LA TUA CARTELLA
    cartella_csv = input("Inserisci il percorso della cartella contenente i CSV: ").strip()
    
    # Verifica che la cartella esista
    if not os.path.exists(cartella_csv):
        print(f"Errore: la cartella {cartella_csv} non esiste")
        return
    
    # Chiedi il nome del file di output (opzionale)
    nome_output = input("Nome del file di output (premi Enter per 'piani_comuni.csv'): ").strip()
    if not nome_output:
        nome_output = "piani_comuni.csv"
    
    # Esegui la funzione principale
    trova_piani_comuni(cartella_csv, nome_output)

def trova_piani_comuni_diretti(file1, file2, file_output="piani_comuni.csv"):
    """
    Trova i piani comuni tra due file CSV specifici
    
    Args:
        file1 (str): Percorso del primo file CSV
        file2 (str): Percorso del secondo file CSV
        file_output (str): Nome del file di output
    """
    try:
        # Carica i due CSV
        df1 = pd.read_csv(file1)
        df2 = pd.read_csv(file2)
        
        # Estrae i tipi dai nomi dei file
        nome1 = os.path.basename(file1)
        nome2 = os.path.basename(file2)

        tipo1 = nome1.replace("plan_", "").replace(".csv", "")
        tipo2 = nome2.replace("plan_", "").replace(".csv", "")

        
        print(f"File 1: {nome1} (tipo: {tipo1}) - {len(df1)} righe")
        print(f"File 2: {nome2} (tipo: {tipo2}) - {len(df2)} righe")
 
        
        # Verifica che entrambi abbiano la colonna 'filename'
        if 'filename' not in df1.columns:
            print(f"Errore: {nome1} non contiene la colonna 'filename'")
            return
        if 'filename' not in df2.columns:
            print(f"Errore: {nome2} non contiene la colonna 'filename'")
            return

        
        # Trova i piani comuni
        piani_file1 = set(df1['filename'].unique())
        piani_file2 = set(df2['filename'].unique())

        piani_comuni = piani_file1.intersection(piani_file2)

        
        print(f"Piani unici nel file 1: {len(piani_file1)}")
        print(f"Piani unici nel file 2: {len(piani_file2)}")
        print(f"Piani comuni: {len(piani_comuni)}")
        
        if not piani_comuni:
            print("Nessun piano comune trovato")
            return
        
        print(f"\nPiani comuni trovati: {sorted(piani_comuni)}")
        
        # Filtra e modifica i dataframe
        df1_comuni = df1[df1['filename'].isin(piani_comuni)].copy()
        df2_comuni = df2[df2['filename'].isin(piani_comuni)].copy()

        
        # Aggiungi i suffissi ai nomi
        df1_comuni['filename'] = df1_comuni['filename'] + f"_{tipo1}"
        df2_comuni['filename'] = df2_comuni['filename'] + f"_{tipo2}"

        
        # Combina i risultati
        df_finale = pd.concat([df1_comuni, df2_comuni], ignore_index=True)
        
        # Salva il risultato
        df_finale.to_csv(file_output, index=False)
        
        print(f"\nRisultato salvato in: {file_output}")
        print(f"Totale righe nel file finale: {len(df_finale)}")
        print(f"Righe da {nome1}: {len(df1_comuni)}")
        print(f"Righe da {nome2}: {len(df2_comuni)}")
        
        print("\nEsempi di nomi modificati:")
        for filename in sorted(df_finale['filename'].unique())[:10]:
            print(f"  - {filename}")
        
        return df_finale
        
    except Exception as e:
        print(f"Errore durante il processing: {e}")
        return None

if __name__ == "__main__":
    # Per usare direttamente con i file che hai caricato
    print("=== ANALISI DEI FILE CARICATI ===")
    trova_piani_comuni_diretti("plan_goal.csv", "plan_coord.csv", "piani_comuni.csv")
    
    print("\n" + "="*50)
    print("Per usare lo script con altri file, decommentare la riga seguente:")
    print("# main()")