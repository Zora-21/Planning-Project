#!/usr/bin/env python3
"""
Script per convertire domini PDDL aggiungendo funzioni balls_at per ogni location
e convertendo goal in snowman_built.
"""

import os
import re
import argparse
from pathlib import Path


def extract_locations(content):
    """Estrae tutte le location dal contenuto PDDL."""
    locations = []
    
    # Cerca nella sezione objects
    objects_match = re.search(r':objects(.*?)(?=:\w|\))', content, re.DOTALL)
    if objects_match:
        objects_section = objects_match.group(1)
        # Trova tutte le location
        location_matches = re.findall(r'(\w+)\s*-\s*location', objects_section)
        locations.extend(location_matches)
    
    return locations


def count_balls_at_location(content, location):
    """Conta quante palle ci sono in una specifica location."""
    count = 0
    # Cerca tutte le occorrenze di ball_at per questa location
    ball_at_pattern = rf'\(ball_at\s+\w+\s+{re.escape(location)}\)'
    matches = re.findall(ball_at_pattern, content)
    count = len(matches)
    return count


def convert_pddl_problem(input_content):
    """Converte il contenuto PDDL secondo le specifiche."""
    
    # Estrai le location
    locations = extract_locations(input_content)
    
    if not locations:
        print("Attenzione: Nessuna location trovata nel file")
        return input_content
    
    # Sostituisci (=(goal) 0) con (= (snowman_built) 0)
    content = re.sub(r'\(\s*=\s*\(\s*goal\s*\)\s*0\s*\)', '(= (snowman_built) 0)', input_content)
    
    # Trova la sezione init
    init_match = re.search(r'(:init.*?)(?=:goal|\(:goal)', content, re.DOTALL)
    if not init_match:
        print("Attenzione: Sezione :init non trovata")
        return content
    
    init_section = init_match.group(1)
    init_start = init_match.start(1)
    init_end = init_match.end(1)
    
    # Genera le funzioni balls_at per ogni location
    balls_at_lines = []
    for location in locations:
        ball_count = count_balls_at_location(content, location)
        balls_at_lines.append(f' (= (balls_at {location}) {ball_count})')
    
    # Trova la posizione dove inserire le funzioni balls_at
    # Le inseriremo dopo (= (snowman_built) 0)
    snowman_built_pattern = r'\(\s*=\s*\(\s*snowman_built\s*\)\s*0\s*\)'
    snowman_match = re.search(snowman_built_pattern, init_section)
    
    if snowman_match:
        # Inserisci dopo snowman_built
        insert_pos = snowman_match.end()
        new_init = (init_section[:insert_pos] + 
                   '\n' + '\n'.join(balls_at_lines) + 
                   init_section[insert_pos:])
    else:
        # Se non troviamo snowman_built, inserisci all'inizio della sezione init
        lines = init_section.split('\n')
        if len(lines) > 1:
            new_init = lines[0] + '\n' + '\n'.join(balls_at_lines) + '\n' + '\n'.join(lines[1:])
        else:
            new_init = init_section + '\n' + '\n'.join(balls_at_lines)
    
    # Sostituisci la sezione init nel contenuto
    content = content[:init_start] + new_init + content[init_end:]
    
    # Sostituisci la sezione goal
    goal_pattern = r'(:goal\s*\(\s*=\s*\(\s*goal\s*\)\s*1\s*\)\s*)'
    content = re.sub(goal_pattern, ':goal\n (= (snowman_built) 1)\n ', content, flags=re.DOTALL)
    
    return content


def process_directory(input_dir, output_dir):
    """Processa tutti i file PDDL in una directory."""
    
    input_path = Path(input_dir)
    output_path = Path(output_dir)
    
    # Crea la directory di output se non esiste
    output_path.mkdir(parents=True, exist_ok=True)
    
    # Pattern per i file da processare: {nome_autore}_problem.pddl
    file_pattern = "problem_*.pddl"
    
    processed_files = 0
    
    for pddl_file in input_path.glob(file_pattern):
        print(f"Processando: {pddl_file.name}")
        
        try:
            # Leggi il file di input
            with open(pddl_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Converti il contenuto
            converted_content = convert_pddl_problem(content)
            
            # Genera il nome del file di output
            output_filename = pddl_file.stem + ".pddl"
            output_file_path = output_path / output_filename
            
            # Salva il file convertito
            with open(output_file_path, 'w', encoding='utf-8') as f:
                f.write(converted_content)
            
            print(f"✓ Convertito: {pddl_file.name} -> {output_filename}")
            processed_files += 1
            
        except Exception as e:
            print(f"✗ Errore nel processare {pddl_file.name}: {str(e)}")
    
    print(f"\nProcessamento completato: {processed_files} file convertiti")


def main():
    """Funzione principale."""
    parser = argparse.ArgumentParser(
        description="Converte domini PDDL aggiungendo funzioni balls_at e convertendo goal in snowman_built"
    )
    
    parser.add_argument(
        "input_dir",
        help="Directory contenente i file PDDL da convertire"
    )
    
    parser.add_argument(
        "output_dir", 
        help="Directory dove salvare i file convertiti"
    )
    
    parser.add_argument(
        "--pattern",
        default="*_problem.pddl",
        help="Pattern per i file da processare (default: *_problem.pddl)"
    )
    
    args = parser.parse_args()
    
    # Verifica che la directory di input esista
    if not os.path.exists(args.input_dir):
        print(f"Errore: La directory di input '{args.input_dir}' non esiste")
        return 1
    
    if not os.path.isdir(args.input_dir):
        print(f"Errore: '{args.input_dir}' non è una directory")
        return 1
    
    print(f"Directory di input: {args.input_dir}")
    print(f"Directory di output: {args.output_dir}")
    print(f"Pattern file: {args.pattern}")
    print("-" * 50)
    
    process_directory(args.input_dir, args.output_dir)
    
    return 0


if __name__ == "__main__":
    exit(main())

    #python3 converter.py /Users/matteo/Documents/Planning-Project/Project/3-snowmen/Goal /Users/matteo/Documents/Planning-Project/Project/3-snowmen/Count_ball