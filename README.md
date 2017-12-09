# A-Priori-Rec

Algorithme d'extraction de règles de classification de champignon. Adaptation d'A Priori avec adaptation du minSup pour couvrir toutes les instances de l'ensemble d'apprentissage.

La logique est la suivante :

 - Tant qu'il reste des instances
 
    - Si itemsets fréquents (avec l'attribut comestible)
    
        - Garder l'itemset avec le support maximal, en faire une regle
        (qui couvre le plus d'instance)
        
        - Retirer de l'ensemble toutes les instances qui verifient cette regle
        
    - Si pas d'itemset frequent
    
        - Reduire le minSup
    
    - Fin Si
- Fin Tant que
