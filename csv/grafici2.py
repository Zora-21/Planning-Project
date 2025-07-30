import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Carica il dataset
try:
    df = pd.read_csv('plan_common.csv')
except FileNotFoundError:
    print("Errore: Il file 'plan_goal_coord.csv' non è stato trovato. Assicurati che sia nella stessa directory dello script.")
    exit()

# Crea una nuova colonna 'Plan Type' basata sul nome del file
def classify_plan_type(filename):
    if 'basic' in filename:
        return 'plan_basic'
    elif 'goal' in filename:
        return 'plan_goal'
    elif 'coord' in filename:
        return 'plan_coord'
    elif 'count' in filename:
        return 'plan_count'
    else:
        return 'other'

df['Plan Type'] = df['filename'].apply(classify_plan_type)

# Filtra solo i tipi di piano che ci interessano
df_filtered = df[df['Plan Type'].isin(['plan_basic', 'plan_goal', 'plan_coord', 'plan_count'])].copy()

print(f"Distribuzione dei tipi di piano:")
print(df_filtered['Plan Type'].value_counts())
print()

# ===== GRAFICO 1: Grafico a barre per le metriche medie =====

# Identifica le colonne da escludere
columns_to_exclude = [
    'filename',
    'Grounding Time',
    'Plan-Length',
    'Plan Type',
    'Metric (Search)',
    'H1 Total Time (msec)',
    'Fixed constraint violations during search (zero-crossing)',
    'H1 Setup Time (msec)'
]

# Aggiungi tutte le colonne Stat_* all'esclusione dinamicamente
for col in df_filtered.columns:
    if col.startswith('Stat_'):
        columns_to_exclude.append(col)

# Ottieni tutte le colonne numeriche rimanenti
numeric_columns = df_filtered.select_dtypes(include=['number']).columns.tolist()

# Filtra le colonne numeriche escludendo quelle non desiderate
metrics_to_analyze = [col for col in numeric_columns if col not in columns_to_exclude]

if not metrics_to_analyze:
    print("Nessuna metrica valida trovata per l'analisi dopo l'esclusione delle colonne specificate.")
    exit()

# Rimuovi eventuali righe con valori NaN nelle metriche che verranno analizzate
df_filtered_clean = df_filtered.dropna(subset=metrics_to_analyze)

# Calcola la media per ogni metrica per tipo di piano
average_metrics = df_filtered_clean.groupby('Plan Type')[metrics_to_analyze].mean().reset_index()

print("Medie delle metriche per tipo di piano:")
print(average_metrics)
print()

# Trasforma i dati per il grafico a barre raggruppato
df_melted = average_metrics.melt(id_vars='Plan Type', var_name='Metric', value_name='Average Value')

# Genera il grafico a barre unico e raggruppato
plt.figure(figsize=(16, 10))

# Colori personalizzati per 4 tipi di piano
custom_colors = ['#7ba2cf', '#94dbef', '#ffa07a', '#98d982']  # Blu chiaro, Azzurro, Salmone, Verde chiaro

sns.barplot(x='Metric', y='Average Value', hue='Plan Type', data=df_melted, palette=custom_colors)

plt.xticks(rotation=45, ha='right')
plt.legend(title='Plan Type', bbox_to_anchor=(1.05, 1), loc='upper left')
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.title('Confronto medie delle metriche per tipo di piano')
plt.tight_layout()
plt.show()

print("Grafico a barre generato con successo!")
print()

# ===== GRAFICO 2: Planning Time vs Numero di piani risolti =====

# Rimuovi eventuali righe con valori NaN nella colonna 'Planning Time (msec)'
df_planning = df_filtered.dropna(subset=['Planning Time (msec)'])

# Assicurati che 'Planning Time (msec)' sia numerico
df_planning['Planning Time (msec)'] = pd.to_numeric(df_planning['Planning Time (msec)'], errors='coerce')

# Rimuovi eventuali righe dove la conversione ha generato NaN
df_planning = df_planning.dropna(subset=['Planning Time (msec)'])

# Separa i dati per ogni tipo di piano
plan_types = ['plan_basic', 'plan_goal', 'plan_coord', 'plan_count']
df_by_type = {}

for plan_type in plan_types:
    df_type = df_planning[df_planning['Plan Type'] == plan_type].copy()
    if not df_type.empty:
        # Ordina i dati in base al 'Planning Time (msec)' in senso crescente
        df_type.sort_values(by='Planning Time (msec)', inplace=True)
        # Genera il "numero di piani risolti" come indice progressivo
        df_type['Piani Risolti'] = range(1, len(df_type) + 1)
        df_by_type[plan_type] = df_type

# Crea il grafico
plt.figure(figsize=(14, 8))

# Colori per ogni tipo di piano (stessi del grafico precedente)
colors = {
    'plan_basic': '#7ba2cf',
    'plan_goal': '#94dbef', 
    'plan_coord': '#ffa07a',
    'plan_count': '#98d982'
}

# Plot per ogni tipo di piano
for plan_type, color in colors.items():
    if plan_type in df_by_type:
        df_type = df_by_type[plan_type]
        plt.plot(df_type['Piani Risolti'], df_type['Planning Time (msec)'], 
                label=f'{plan_type.title()}', marker='o', linestyle='-', 
                markersize=4, color=color, alpha=0.8)

# Imposta la scala logaritmica per l'asse Y
plt.yscale('log')

# Aggiungi etichette e titolo
plt.xlabel('Number of plans resolved')
plt.ylabel('Planning Time (msec)')
plt.title('Planning Time vs Number of Plans Resolved (Log Scale)')
plt.legend()
plt.grid(True, which="both", ls="", alpha=0.3)

# Mostra il grafico
plt.tight_layout()
plt.show()

print("Grafico Planning Time generato con successo!")

# ===== STATISTICHE RIASSUNTIVE =====
print("\n=== STATISTICHE RIASSUNTIVE ===")
for plan_type in plan_types:
    if plan_type in df_by_type:
        df_type = df_by_type[plan_type]
        print(f"\n{plan_type.upper()}:")
        print(f"  - Numero di piani: {len(df_type)}")
        print(f"  - Planning Time medio: {df_type['Planning Time (msec)'].mean():.2f} msec")
        print(f"  - Planning Time mediano: {df_type['Planning Time (msec)'].median():.2f} msec")
        print(f"  - Planning Time min: {df_type['Planning Time (msec)'].min():.2f} msec")
        print(f"  - Planning Time max: {df_type['Planning Time (msec)'].max():.2f} msec")
    else:
        print(f"\n{plan_type.upper()}: Nessun dato trovato")