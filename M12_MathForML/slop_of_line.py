
def get_slop_inter(points1, points2):

    x1, y1 = points1
    x2, y2 = points2


    # Handle vertical line (undefined slope) separately
    if x2 - x1 == 0:
        if all(x == x1 for x, _ in points):
            return None, x1  # Slope is None, and the x-intercept is x1 for vertical line
        return -1

    m = (y2 - y1) / (x2 - x1)
    c = y1 - m * x1

    return (m, c)


def straight_line_or_not(coordinates):

    """
        Input is the list of tuples containg the coordiantes.
        Fucntion computes the slope and intercept if the points lies in a straight line.
        If lie straight line return the tuple (slope,intercept) having float values till one deciaml point.
        else, return -1
    """
    
    m, c = get_slop_inter(coordinates[0], coordinates[1])

    for points in coordinates[2:]:
        x, y = points[0], points[1]

        if abs((y - m * x + c)) < 1e-9:
            return -1 

    return (m, c)

print(straight_line_or_not([(1.0, 5.0), (-3.0, -3.0), (2.5, 8.0)]))
