I need to calculate average life expectancy for each language in two ways: first using a simple (but statistically incorrect) average across all countries, then developing a more accurate method that properly weights the data. This is fundamentally a question about statistical methodology and the importance of weighted averages in real-world analysis.

This task has two distinct parts that build on each other. The first part is straightforward - just average life expectancy across countries for each language. The second part requires deeper statistical thinking about what "average life expectancy for a language" actually means and how to calculate it meaningfully.

The obvious approach of just averaging life expectancy across countries treats each country equally, regardless of population size or percentage of speakers. This creates misleading results because it gives equal weight to English in Malta (500k people) and English in the United States (330M people). A small country with extreme values can skew the entire language average inappropriately.

## The Logic Flow for Correct Method

1. Calculate actual number of speakers per country: (Population × Language_Percentage) / 100;
2. Use weighted average formula: Σ(Life_Expectancy × Speakers) / Σ(Speakers);
3. Add data quality filters to exclude unreliable records;
4. Consider additional weighting factors like official language status;
5. Compare results between simple and weighted methods to show the difference

## Step-by-Step Reasoning

Start with the relationship: countrylanguage.CountryCode = country.Code to link languages with countries. The next step is calculation of speakers: Population * Percentage / 100 gives real number of people speaking each language. Then apply weighted average -- instead of treating countries equally, weight by actual speaker population. After this add sophistication -- official languages might deserve higher weight since they're more representative. The next step is filtering for significance, only include languages with substantial speaker populations (1M+ speakers). And finally compare methods, that means showing side-by-side results to demonstrate why weighting matters.