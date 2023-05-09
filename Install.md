# Production régionalisée reproductible Onde 

Ce document décrit pas à pas l'installation et la mise à jour de l'outil **PRR Onde** Ces opérations utilisent les services de la plateforme GitHub. Elles requièrent uniquement la création d'un compte sur cette plateforme.

## Installation de l'outil
1. Se connecter à Github
2. Naviguer vers le dépôt https://github.com/richaben/prr_onde
3. Cliquer sur le bouton `Fork` en haut à droite de la page d'accueil du dépôt. Cette action lance la copie du dépôt dans l'espace de l'utilisateur GitHub connecté.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/3f989505-5419-460a-9a7d-be2749f8b9b3)

   Un formulaire de paramétrage du nouveau dépôt apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/a2501275-e4bb-4465-af3a-d7191fa11e40)

4. Décocher l'option `Copy the master branch only` et cliquer sur le bouton `Create fork`. Une fois la copie réalisée, le dépôt apparaît dans l'espace de travail de l'utilisateur connecté.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/1aa9b99f-dfc5-4dd1-adc4-792f8cf897d8)

5. Cliquer sur le bouton `Settings`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/8d915f4d-4439-4da2-bb14-643d23626936)

   L'écran de paramétrage du dépôt apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/e7b7f69a-d5b7-478f-a89a-14368196aeb9)

6. Cliquer sur l'élément `Code and automation > Pages` pour afficher les paramètres du service Github Pages. Ce service permet d'associer un site web au dépôt GitHub.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/367ff019-3ff8-484c-bcde-229ca0e9649e)

7. Dans la section `Branch`, sélectionner `deploy` et `root` puis cliquer sur le bouton `Save` Le dépôt dispose désormais d'une page web sur Github Pages. Son url est de la forme https://{identifiant de l'utilisateur github}.github.io/PRR_ONDE/ Exemple : https://ofb_normandie.github.io/PRR_ONDE/

8. Cliquer sur l'élément `Code and automation > Actions > General` pour afficher les paramètres généraux du service Github Actions. Ce service permet d'automatiser l'exécution d'un traitement.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/0ee603a0-8fcd-46f0-a5db-6b0fd6967e71)

9. Dans la section `Workflow permissions` en bas de l'écran, sélectionner `Read and write permissions` puis cliquer sur le bouton `Save`.

![image](https://user-images.githubusercontent.com/63242934/225863756-c601b08c-2e04-456e-814f-e826eb4c84a4.png)

10. Afficher de nouveau la page d'accueil du dépôt et cliquer sur le bouton de paramétrage du panneau `About` à droite de l'écran.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/289b9820-769d-46db-b485-a50ad30094e6)

    Une fenêtre apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/5637638d-39b5-4229-aebd-482fb1c06178)

11. Renseigner le champ `Website` avec l'url de la page Github Pages mentionnée ci-dessus puis cliquer sur le bouton `Save changes`. L'url doit apparaître dans le panneau `About`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/6588c97c-6a49-43a4-b2e6-0972daa336d7)

12. Cliquer sur l'élément `Actions`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/3ca9abb1-cef2-469d-b518-32c711cbd952)

    La fenêtre suivante apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/0eb34c98-545d-4937-b37e-7e3dbee7a767)

13. Cliquer sur le bouton `I understand my workflows, go ahead and enable them` La liste des flux de travail (workflow) apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/783ba554-3f05-4463-b964-dad564b05d42)

La liste comprend :
    - un workflow de synchronisation les branches `master` et `deploy`
    - un workflow d'actualisation quotidienne du site web

14. Cliquer sur l'item `Script_R_ONDE_carto_auto`. Le paramétrage du flux de travail apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/0739fcc0-51fb-4117-aad9-9b79a816276e)

15. Cliquer sur le bouton `Enable workflow` pour activer le flux de travail.

A ce stade, toute modification du code ou, à minima, chaque matin le site web est actualisé. Le contenu de la page, sa mise en forme et/ou la fréquence de son actualisation peuvent être librement modifiés.

16. Afficher la page d'accueil du dépôt et cliquer sur le script R `_config.R` à la racine du dépôt :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/ecdd196e-2ae4-48ac-aba0-d7e5dfd3cbce)

   Le code R du script apparaît à l'écran :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/95c28ba8-9748-400a-b288-377a3d6076f3)

17. Cliquer sur le bouton `Edit this file` et adapter le paramétrage à la région cible. **Important** : les codes de département doivent être encadrés par des `"` et préfixés par `0`pour les départements dont le code est inférieur à 10.

18. Une fois le paramétrage renseigné, cliquer sur le bouton `Commit changes`

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/94aeb53f-9e82-47c9-8414-79f9edf7b58a)

    Une fenêtre apparaît :
    
![image](https://github.com/richaben/PRR_ONDE/assets/63242934/34fab0f7-b03b-411a-adf2-860cffcd4218)
    
19. Renseigner `Adaptation du traitement à la région` dans le champ `Commit message` et cliquer sur le bouton `Commit changes` Une fois enregistré, le script réapparaît en lecture seule. Cette modification de code entraine l'actualisation du site web. Il est possible de suivre l'avancement du traitement en cliquant sur le libellé du flux de travail (menu `Actions`puis cliquer sur le script R adéquat :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/99f52d89-b364-424e-9f18-8e45c8cadc19)

    Il est également possible de suivvre le détail des traitements en cliquant de nouveau sur le libellé du script R.

![image](https://user-images.githubusercontent.com/63242934/225867577-1426d7ba-43ca-4381-8dc3-a835290dcedd.png)

Une fois la page web ré générée, naviguer vers https://ofb_normandie.github.io/PRR_ONDE/ La page doit afficher les données de la région.

## Mise à jour de l'outil

1. Se connecter à GitHub
2. Afficher la page d'accueil du dépôt PRR_ONDE. Un message `This branch is ...`doit apparaître.

![image](https://user-images.githubusercontent.com/63242934/237046767-a60dab0b-f53e-460c-aeec-fde098584495.png)

4. Cliquer sur le bouton `Sync fork` Une fenêtre de validation apparaît.
5. Cliquer sur le bouton `Update branch` 

La mise à jour de l'outil est déclenchée. Dans la foulée, la page web est ré générée.

## Exécution manuelle de la génération de la page web

1. Cliquer sur le bouton `Run workflow` pour lancer l'exécution du flux de travail et confirmer l'opération.

![image](https://user-images.githubusercontent.com/63242934/225866603-fc736f22-c58c-4c3e-af7d-7014ed6c5267.png)

    
