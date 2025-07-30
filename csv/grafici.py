import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns # Useremo seaborn per un aspetto migliore dei grafici

# Carica il dataset
try:
    df = pd.read_csv('plan_goal_coord.csv')
except FileNotFoundError:
    print("Errore: Il file 'plan_basic_goal.csv' non è stato trovato. Assicurati che sia nella stessa directory dello script.")
    exit()

# Crea una nuova colonna 'Plan Type' basata sul nome del file
df['Plan Type'] = df['filename'].apply(lambda x: 'plan_coord' if 'coord' in x else ('plan_goal' if 'goal' in x else 'other'))

# Filtra solo i tipi di piano che ci interessano ('plan_basic' e 'plan_goal')
df_filtered = df[df['Plan Type'].isin(['plan_coord', 'plan_goal'])].copy() # .copy() per evitare SettingWithCopyWarning

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
df_filtered.dropna(subset=metrics_to_analyze, inplace=True)

# Calcola la media per ogni metrica per tipo di piano
average_metrics = df_filtered.groupby('Plan Type')[metrics_to_analyze].mean().reset_index()

print("Medie delle metriche per tipo di piano:")
print(average_metrics)

# Trasforma i dati per il grafico a barre raggruppato
# `melt` trasforma le colonne delle metriche in righe, utile per seaborn
df_melted = average_metrics.melt(id_vars='Plan Type', var_name='Metric', value_name='Average Value')

# Genera il grafico a barre unico e raggruppato
plt.figure(figsize=(15, 8)) # Aumenta la dimensione del grafico per una migliore leggibilità

# --- MODIFICHE AI COLORI QUI ---

custom_colors = ['#7ba2cf','#94dbef'] # Blu e Arancione (colori predefiniti di Matplotlib/Seaborn)


sns.barplot(x='Metric', y='Average Value', hue='Plan Type', data=df_melted, palette=custom_colors)


# --- FINE MODIFICHE AI COLORI ---

plt.xticks(rotation=45, ha='right') # Ruota le etichette delle metriche per evitare sovrapposizioni
plt.legend(title='Type')
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout() # Adatta automaticamente i parametri della figura per riempire l'area della figura
plt.show()

print("\nGrafico unico generato con successo!")