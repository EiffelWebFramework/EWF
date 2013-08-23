# Implementing routines in WSF_OPTIONS_POLICY

This class provides a default response to OPTIONS requests other than OPTIONS *. So you don't have to do anything. The default response just includes the mandatory Allow headers for all the methods that are allowed for the request URI. if you want to include a body text, or additional header, then you should redefine this routine.