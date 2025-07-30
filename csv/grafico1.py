import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Carica il dataset
try:
    df = pd.read_csv('plan_goal_coord.csv')
except FileNotFoundError:
    print("Errore: Il file 'plan_basic_goal.csv' non è stato trovato.")
    print("Assicurati che il file sia nella stessa directory dello script o fornisci il percorso completo.")
    exit()

# Rimuovi eventuali righe con valori NaN nella colonna 'Planning Time (msec)' che potrebbero causare problemi con la scala logaritmica
df.dropna(subset=['Planning Time (msec)'], inplace=True)

# Assicurati che 'Planning Time (msec)' sia numerico
df['Planning Time (msec)'] = pd.to_numeric(df['Planning Time (msec)'], errors='coerce')

# Rimuovi eventuali righe dove la conversione ha generato NaN (errori)
df.dropna(subset=['Planning Time (msec)'], inplace=True)

# Filtra i dati per plan_basic e plan_goal
df_coord = df[df['filename'].str.contains('_coord', na=False)].copy()
df_goal = df[df['filename'].str.contains('_goal', na=False)].copy()

# Ordina i dati in base al 'Planning Time (msec)' in senso crescente
df_coord.sort_values(by='Planning Time (msec)', inplace=True)
df_goal.sort_values(by='Planning Time (msec)', inplace=True)

# Genera il "numero di piani risolti" come indice progressivo dopo l'ordinamento
df_coord['Piani Risolti'] = range(1, len(df_coord) + 1)
df_goal['Piani Risolti'] = range(1, len(df_goal) + 1)

# Crea il grafico
plt.figure(figsize=(12, 5))

# Plot per plan_basic
plt.plot(df_coord['Piani Risolti'], df_coord['Planning Time (msec)'], label='Plan Coord', marker='o', linestyle='-', markersize=4 , color='#7ba2cf')

# Plot per plan_goal
plt.plot(df_goal['Piani Risolti'], df_goal['Planning Time (msec)'], label='Plan Goal', marker='o', linestyle='-', markersize=4, color ='#94dbef')

# Imposta la scala logaritmica per l'asse Y
plt.yscale('log')

# Aggiungi etichette e titolo
plt.xlabel('Number of plans resolved')
plt.ylabel('Planning-Time (msec)')
plt.legend()
plt.grid(True, which="both", ls="", c='0.7') # Griglia per entrambe le scale

# Mostra il grafico
plt.tight_layout()
plt.show()