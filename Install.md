# Production régionalisée reproductible Onde 

Ce document décrit pas à pas l'installation et la mise à jour de l'outil **PRR Onde**. Ces opérations utilisent les services de la plateforme GitHub. Elles requièrent uniquement la création d'un compte sur cette plateforme.

## Installation de l'outil
Prérequis : disposer d'un compte GitHub.
  
1. Se connecter à Github
2. Naviguer vers le dépôt GitHub de référence de l'outil, https://github.com/richaben/prr_onde
3. Cliquer sur le bouton `Fork` en haut à droite de la page d'accueil du dépôt. Cette action lance la copie du dépôt dans l'espace de l'utilisateur GitHub connecté.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/3f989505-5419-460a-9a7d-be2749f8b9b3)

   Un formulaire de paramétrage du nouveau dépôt apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/5821c222-fada-41b9-b295-5c48059f396e)

4. Décocher l'option `Copy the master branch only` et cliquer sur le bouton `Create fork`. Une fois la copie réalisée, le dépôt apparaît dans l'espace de travail de l'utilisateur connecté.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/1aa9b99f-dfc5-4dd1-adc4-792f8cf897d8)

5. Cliquer sur le bouton `Settings`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/8d915f4d-4439-4da2-bb14-643d23626936)

   L'écran de paramétrage du dépôt apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/e7b7f69a-d5b7-478f-a89a-14368196aeb9)

6. Cliquer sur l'élément `Code and automation > Pages` pour afficher les paramètres du service `Github Pages`. Ce service permet d'associer un site web à un dépôt GitHub.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/367ff019-3ff8-484c-bcde-229ca0e9649e)

7. Dans la section `Branch`, sélectionner `deploy` et `root` puis cliquer sur le bouton `Save` Le dépôt dispose désormais d'un site web hébergé par `Github Pages`. L'url d'accès à ce site est de la forme https://{identifiant de l'utilisateur github}.github.io/PRR_ONDE/ Exemple : https://ofb_normandie.github.io/PRR_ONDE/

8. Afficher de nouveau la page d'accueil du dépôt et cliquer sur le bouton de paramétrage du panneau `About` (bouton symbolisé par un engrenage à droite de l'écran).

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/289b9820-769d-46db-b485-a50ad30094e6)

   Une fenêtre apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/5637638d-39b5-4229-aebd-482fb1c06178)

9. Renseigner le champ `Website` avec l'url du site web du dépôt puis cliquer sur le bouton `Save changes`. L'url doit désormais apparaître dans le panneau `About`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/6588c97c-6a49-43a4-b2e6-0972daa336d7)

10. Cliquer sur l'élément `Code and automation > Actions > General` pour afficher les paramètres généraux du service `Github Actions`. Ce service permet d'automatiser l'exécution d'un traitement.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/0ee603a0-8fcd-46f0-a5db-6b0fd6967e71)

11. Dans la section `Workflow permissions` en bas de l'écran, sélectionner `Read and write permissions` puis cliquer sur le bouton `Save`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/1eae7e65-d0a8-4368-86a8-460694e941f9)

12. Cliquer sur l'élément `Actions`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/3ca9abb1-cef2-469d-b518-32c711cbd952)

   La fenêtre suivante apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/b9a9e075-e210-4f6f-b31b-a2f19baba804)

13. Cliquer sur le bouton `I understand my workflows, go ahead and enable them` La liste des traitements automatisés ou flux de travail (*workflow* en anglais) apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/783ba554-3f05-4463-b964-dad564b05d42)

La liste comprend :
    - la synchronisation automatique des branches `master` et `deploy` après chaque mise à jour de l'outil ;
    - l'actualisation quotidienne du site web après chaque mise à jour des données Onde.

14. Cliquer sur l'item `Script_R_ONDE_carto_auto`. Le paramétrage de l'actualisation des données apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/0739fcc0-51fb-4117-aad9-9b79a816276e)

15. Cliquer sur le bouton `Enable workflow` pour activer le déclenchement automatique du traitement.

A ce stade, toute mise à jour de l'outil ou des données entraine une actualisation du site web.

> Le contenu de la page, sa mise en forme et/ou la fréquence de son actualisation restent paramétrables.

16. Afficher la page d'accueil du dépôt et cliquer sur le script R `_config.R` à la racine du dépôt :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/ecdd196e-2ae4-48ac-aba0-d7e5dfd3cbce)

   Le code R du script apparaît à l'écran :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/95c28ba8-9748-400a-b288-377a3d6076f3)

17. Cliquer sur le bouton `Edit this file` et adapter le paramétrage à une région de France. **Important** : les codes de département doivent être encadrés par des `"` et préfixés par `0`pour les départements dont le code est inférieur à 10.  

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/848cfe10-dbb9-4e5a-8971-4e812b55c051)

18. Une fois le paramétrage renseigné, cliquer sur le bouton `Commit changes`

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/94aeb53f-9e82-47c9-8414-79f9edf7b58a)

   Une fenêtre apparaît :
    
![image](https://github.com/richaben/PRR_ONDE/assets/63242934/34fab0f7-b03b-411a-adf2-860cffcd4218)
    
19. Renseigner `Adaptation du traitement à la région` dans le champ `Commit message` et cliquer sur le bouton `Commit changes` Une fois enregistré, le script réapparaît en lecture seule. Cette modification de code déclenche l'actualisation du site web. Il est alors possible de suivre l'avancement du traitement en cliquant sur le libellé du script de traitement :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/99f52d89-b364-424e-9f18-8e45c8cadc19)

   Il est également possible de suivre chaque étape du traitement en cliquant de nouveau sur le libellé du script R :

![image](https://user-images.githubusercontent.com/63242934/225867577-1426d7ba-43ca-4381-8dc3-a835290dcedd.png)

   Une fois le traitement terminé, il est possible de vérifier son résultat et sa durée :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/ee83f0b6-1054-4a35-9273-d6803f0b8702)

20. En cas de succès, consulter le site web actualisé en activant le lien depuis la page d'accueil du dépôt :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/6588c97c-6a49-43a4-b2e6-0972daa336d7)

## Mise à jour de l'outil

1. Se connecter à GitHub
2. Afficher la page d'accueil du dépôt `PRR_ONDE`. Un message `This branch is ...`doit apparaître.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/50d9005d-acee-43a1-a052-9b9187d0cf48)

3. Cliquer sur le bouton `Sync fork` Une fenêtre de validation apparaît.
4. Cliquer sur le bouton `Update branch` 

La mise à jour de l'outil est déclenchée, suivie par l'actualisation du site web. Une fois les traitements terminés, les modifications sont reflétées dans la nouvelle version du site web.

## Enregistrement d'une demande d'amélioration de l'outil

1. Se connecter à GitHub
2. Naviguer vers le dépôt GitHub de référence de l'outil, https://github.com/richaben/prr_onde **Important** : pour centraliser l'ensemble des demandes, celles-ci ne doivent pas être enregistrées dans les dépôts régionaux résultant d'une copie du dépôt de référence.
3. Cliquer sur l'élément `Issues`

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/c2e90117-239b-4ff8-8f79-454aed4d9fb5)

  La liste des demandes apparaît.
  
4. Cliquer sur le bouton `New issue`

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/83fb2e1b-7f94-4c21-b310-9b3accd0e696)
  Un formulaire de saisie de la demande apparaît :

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/d3d5b962-3575-4b4b-80bb-730b73cdd61d)

5. Renseigner un titre concis et une description de la demande puis cliquer sur le bouton `Submit new issue`

  Un dialogue s'engage alors avec l'équipe en charge du développement de l'outil. Ce dialogue peut donner conduire à plusieurs échanges sur un fil de discusssion associé à la demande (*issue*)

6. Une fois la demande traitée, renseigner un dernier message de validation et cliquer sur le bouton `Close with comment`

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/74b1fb2e-a75d-45ca-8a1b-8db459cbb27f)

## Actualisation manuelle du site web
En cas d'eereur des traitements automatiques, il est possible de relancer manuellement l'actualisation du site web en suivant les étapes suivantes :

1. Se connecter à GitHub
2. Afficher la page d'accueil du dépôt `PRR_ONDE`
3. Cliquer sur l'élément `Actions`
4. Cliquer sur le script d'actualisation du site web
5. Cliquer sur le bouton `Run workflow` Une fenêtre apparaît.
6. Sélectionner la branche `deploy` puis cliquer sur le bouton `Run workflow`.

![image](https://github.com/richaben/PRR_ONDE/assets/63242934/eb329fca-918e-400e-93b9-efa0998fb9eb)

    
