import copy
def man_of_match(names, runs, wickets, bowls):
    '''
    input:
    names -> list of names of the players
    runs -> list of runs of the respective players
    wickets -> list of wickets taken by the respective players
    bowls -> list of bowls by the respective players

    output:
    data -> data of the players in dictionary format
    manOfMatch -> name of the man of the match

    The strike rate is calculated by dividing the number of runs by the bowls played by the player.
    Criteria for the man of the match are as follows:

    If strike rate >(greater than) 4 and wickets >(greater than)2: Man of the match

    If strike rate < 4 but >2 and wickets >4: Man of the match

    Return the final records and man of the match.

    '''
    data = dict()
    manOfMatch = ""

    # Your code starts here
    for i in range(len(names)):
        sr = runs[i] / bowls[i]
        data[names[i]] = [runs[i], wickets[i], bowls[i]]

        if sr > 4 and wickets[i] > 2:
            manOfMatch = names[i]
        elif sr <= 4 and sr > 2 and wickets[i] > 4:
            manOfMatch = names[i]


    # Your code ends here
    return data, manOfMatch


names = ["Arun", "Nihal", "Sanjay"]
runs = [25, 50, 10]
wickets = [3, 5, 4]
bowls = [7, 12, 3]


man_of_match(names, runs, wickets, bowls)