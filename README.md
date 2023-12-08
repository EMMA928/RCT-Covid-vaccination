# RCT-Covid-vaccination
The team is conducting a field experiment to assess the effectiveness of different Facebook ad campaigns in increasing COVID-19 vaccine uptake. The experiment involves two distinct ad strategies appealing to reason and emotions.

Total participants: 5,000 across the US.
Random assignment: 1/3 receive the first ad (reason), 1/3 the second ad (emotions), and 1/3 none (control group).
Baseline survey completed by all participants; endline survey completed by 4,500 participants.

I first simulate a baseline survey dataset of demographic features based mainly on nominal and binomial distributions. After that, I randomly allocated 1/3 of the total participants to either control, facts, or emotions groups. Considering there might be a non-compliance problem that people receiving the article on the effectiveness of vaccines in preventing the virus may not read it, I set the probability of disobey to be 0.2. To see whether the RCT experiment is successful, I check the balance of demographic features within each group and test whether the differences among them are significant. Considering there are noncompliance problems, I differentiate the treatment effects based on whether a participant obeys the guidelines and which group he or she is allocated to. I merged the datasets during and after the experiments to create a comprehensive list of all participants before and after the RCT experiments to facilitate further analysis. Finally, I do a regression analysis to figure out the treatment effects of both facts and emotions and visualize them.
