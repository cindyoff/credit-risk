# checking for duplicates
df = df.sort_values(by = ["id", "time"], ascending = [True, False])

# deleting duplicates by keeping the first line by "id" (with the most recent time frame)
df = df.drop_duplicates(subset = "id", keep = "first")

# creating clear labels
payoff_fmt = {0: "Not paid back", 1: "Paid back"}
status_fmt = {1: "Credit default", 2: "Paid back"}
retype_co_fmt = {0: "Non-condominium", 1: "Condominium"}
retype_pu_fmt = {0: "Non-PUD (Planned Unit Development)", 1: "PUD (Planned Unit Development)"}
retype_sf_fmt = {0: "Non-individual house", 1: "Individual house"}
investor_fmt = {0: "Residency", 1: "Investment"}

# computing clear labels
df["payoff_time_label"] = df["payoff_time"].map(payoff_fmt)
df["status_time_label"] = df["status_time"].map(status_fmt)
df["REtype_CO_orig_time_label"] = df["REtype_CO_orig_time"].map(retype_co_fmt)
df["REtype_PU_orig_time_label"] = df["REtype_PU_orig_time"].map(retype_pu_fmt)
df["REtype_SF_orig_time_label"] = df["REtype_SF_orig_time"].map(retype_sf_fmt)
df["investor_orig_time_label"] = df["investor_orig_time"].map(investor_fmt)

