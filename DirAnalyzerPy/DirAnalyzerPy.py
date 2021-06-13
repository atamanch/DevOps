# DirAnalyzerPy analyzes a directory on your local system
# Credit Where It Is Due : https://janakiev.com/blog/python-filesystem-analysis/

#%%
import os
import matplotlib.pyplot as plt
import folderstats
# %%
# Set the directory of interest here
df = folderstats.folderstats('D:\\Gitrepos\\pandas\\pandas-master', ignore_hidden=True)

# %%
with plt.style.context('ggplot'):
    df['extension'].value_counts().plot(
        kind='bar', color='C1', title='Extension Distribution by Count');
# %%

#%%
with plt.style.context('ggplot'):
    # Group by extension and sum all sizes for each extension 
    extension_sizes = df.groupby('extension')['size'].sum()
    # Sort elements by size
    extension_sizes = extension_sizes.sort_values(ascending=False)
    
    extension_sizes.plot(
        kind='bar', color='C1', title='Extension Distribution by Size');
# %%

# %%
with plt.style.context('ggplot'):
    # Filter the data set to only folders
    df_folders = df[df['folder']]

    # Set the name to be the index (so we can use it as a label later)
    df_folders.set_index('name', inplace=True)
    # Sort the folders by size
    df_folders = df_folders.sort_values(by='size', ascending=False)
    
    # Show the size of the largest 50 folders as a bar plot
    df_folders['size'][:50].plot(kind='bar', color='C0', title='Folder Sizes');

print(df_folders)

# %%