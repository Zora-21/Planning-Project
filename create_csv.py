import os
import re
import csv
import argparse
from pathlib import Path

def extract_data_from_plan_file(file_path):
    """Estrae i dati da un singolo file *_plan.txt"""
    
    # Ottieni il nome del file senza estensione e rimuovi '_plan'
    filename = Path(file_path).stem.replace('_plan_with_coord', '')
    
    data = {
        'filename': filename,
        'Grounding Time': '',
        'Stat_F': '',
        'Stat_X': '',
        'Stat_A': '',
        'Stat_P': '',
        'Stat_E': '',
        'H1 Setup Time (msec)': '',
        'Plan-Length': '',
        'Metric (Search)': '',
        'Planning Time (msec)': '',
        'Heuristic Time (msec)': '',
        'Search Time (msec)': '',
        'Expanded Nodes': '',
        'States Evaluated': '',
        'Fixed constraint violations during search (zero-crossing)': '',
        'Number of Dead-Ends detected': '',
        'Number of Duplicates detected': ''
    }
    
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
            
        # Pattern per estrarre i vari campi
        patterns = {
            'Grounding Time': r'Grounding Time[:\s]+([0-9.]+)',
            'Stat_F': r'Stat_F[:\s]+([0-9.]+)',
            'Stat_X': r'Stat_X[:\s]+([0-9.]+)',
            'Stat_A': r'Stat_A[:\s]+([0-9.]+)',
            'Stat_P': r'Stat_P[:\s]+([0-9.]+)',
            'Stat_E': r'Stat_E[:\s]+([0-9.]+)',
            'H1 Setup Time (msec)': r'H1 Setup Time \(msec\)[:\s]+([0-9.]+)',
            'Plan-Length': r'Plan-Length[:\s]+([0-9.]+)',
            'Metric (Search)': r'Metric \(Search\)[:\s]+([0-9.]+)',
            'Planning Time (msec)': r'Planning Time \(msec\)[:\s]+([0-9.]+)',
            'Heuristic Time (msec)': r'Heuristic Time \(msec\)[:\s]+([0-9.]+)',
            'Search Time (msec)': r'Search Time \(msec\)[:\s]+([0-9.]+)',
            'Expanded Nodes': r'Expanded Nodes[:\s]+([0-9.]+)',
            'States Evaluated': r'States Evaluated[:\s]+([0-9.]+)',
            'Fixed constraint violations during search (zero-crossing)': r'Fixed constraint violations during search \(zero-crossing\)[:\s]+([0-9.]+)',
            'Number of Dead-Ends detected': r'Number of Dead-Ends detected[:\s]+([0-9.]+)',
            'Number of Duplicates detected': r'Number of Duplicates detected[:\s]+([0-9.]+)'
        }
        
        # Estrai i dati usando le regex
        for field, pattern in patterns.items():
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                data[field] = match.group(1)
                
    except Exception as e:
        print(f"Errore nel processare il file {file_path}: {e}")
    
    return data

def process_folder(folder_path, output_file='data_goal.csv'):
    """Processa tutti i file *_plan.txt nella cartella e salva i risultati in CSV"""
    
    folder_path = Path(folder_path)
    
    if not folder_path.exists():
        print(f"Errore: La cartella {folder_path} non esiste")
        return
    
    # Trova tutti i file che terminano con '_plan.txt'
    plan_files = list(folder_path.glob('*_plan_with_coord.txt'))
    
    if not plan_files:
        print(f"Nessun file *_plan.txt trovato nella cartella {folder_path}")
        return
    
    print(f"Trovati {len(plan_files)} file da processare...")
    
    # Lista per contenere tutti i dati
    all_data = []
    
    # Processa ogni file
    for plan_file in plan_files:
        print(f"Processando: {plan_file.name}")
        data = extract_data_from_plan_file(plan_file)
        all_data.append(data)
    
    # Salva i dati in CSV
    if all_data:
        fieldnames = [
            'filename', 'Grounding Time', 'Stat_F', 'Stat_X', 'Stat_A', 'Stat_P', 'Stat_E',
            'H1 Setup Time (msec)', 'Plan-Length', 'Metric (Search)', 'Planning Time (msec)',
            'Heuristic Time (msec)', 'Search Time (msec)', 'Expanded Nodes', 'States Evaluated',
            'Fixed constraint violations during search (zero-crossing)',
            'Number of Dead-Ends detected', 'Number of Duplicates detected'
        ]
        
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(all_data)
        
        print(f"\nDati salvati in {output_file}")
        print(f"Processati {len(all_data)} file con successo")
    else:
        print("Nessun dato da salvare")

def main():
    parser = argparse.ArgumentParser(description='Estrae dati da file *_plan.txt')
    parser.add_argument('folder', help='Percorso della cartella contenente i file *_plan.txt')
    parser.add_argument('-o', '--output', default='plan_goal.csv', 
                       help='Nome del file CSV di output (default: plan_goal.csv)')
    
    args = parser.parse_args()
    
    process_folder(args.folder, args.output)

if __name__ == "__main__":
    main()