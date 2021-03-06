import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'queue_info_page.dart';
import 'join_or_create.dart';

class ChooseSongPage extends StatefulWidget {
  @override
  _ChooseSongPageState createState() => new _ChooseSongPageState();
}

class _ChooseSongPageState extends State<ChooseSongPage> {

  // this will be called when the user presses the select button
  void selectMe(int index) {
    globals.selectedSongIndex = index;
    globals.participantList.add(globals.userUserName);
    globals.participantSongs.add(globals.djSonglist[index]);
    // SEAN: We now have the selected song from the user.  This should be sent back to the server
    // so that it can go in the Queue for the event/DJ.
    // Variable: index (index of both the song and the artist arrays)
    // Song Array: globals.djSonglist
    // Artist Array: globals.djArtistlist
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new QueueInfoPage()));
  }

  // indicates whether to display search results or entire list
  bool searching = false;

  // these variables exist to adjust the visual display of the logout button when pressed
  Color backColor = Colors.white;
  bool yesNoVisible = false;
  IconData beginIcon = Icons.close;
  bool userLeaving = false;
  String leaveButtonText = "Leave Event";
  Color beginColor = Colors.black;

  void leaveEvent() {
    // If participant wants to leave...
    if (!userLeaving) {
      userLeaving = true;
      backColor = Colors.white;
      leaveButtonText = "Are you sure?";
      beginIcon = Icons.warning;
      yesNoVisible = true;
      setState(() {});
    }
  }

  // if participant is trying to finish event, display "Yes" and "no" buttons
  void yesOrNo(bool yesNo) {
    // if yes, exit event
    if (yesNo) {
      globals.participantList.removeLast();
      globals.participantSongs.removeLast();
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new JoinOrCreatePage()));
    }
    // if no, go back to previous state
    else {
      userLeaving = false;
      backColor = Colors.white;
      leaveButtonText = "Leave Event";
      beginIcon = Icons.close;
      yesNoVisible = false;
      setState(() {});
    }
  }

  // when user presses "logout", this method is used to help facilitate the button changes
  // for transitioning to "are you sure?"
  Row exitButton() {
    return new Row(mainAxisAlignment: MainAxisAlignment.center, children: <
        Widget>[
      yesNoVisible
          ? new RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: new RichText(
                text: new TextSpan(
                  text: "Yes",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    letterSpacing: 1.0,
                    height: 1.5,
                  ),
                ),
              ),
              color: Colors.blueGrey,
              splashColor: Colors.cyan,
              padding:
                  EdgeInsets.only(left: 4.0, right: 4.0, bottom: 6.0, top: 2.0),
              // if they press this button ("yes"), continue with leave event process
              onPressed: () => yesOrNo(true),
            )
          : new Text(""),
      new Icon(beginIcon),
      // this "button" really just displays "are you sure?"
      new RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: new RichText(
          text: new TextSpan(
            text: leaveButtonText,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
              letterSpacing: 1.0,
              height: 1.5,
            ),
          ),
        ),
        color: beginColor,
        padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 6.0, top: 2.0),
        onPressed: leaveEvent,
      ),
      new Icon(beginIcon),
      // if user changes their mind and presses "no", go back to previous state
      yesNoVisible
          ? new RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: new RichText(
                text: new TextSpan(
                  text: "No",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    letterSpacing: 1.0,
                    height: 1.5,
                  ),
                ),
              ),
              splashColor: Colors.cyan,
              color: Colors.blueGrey,
              padding:
                  EdgeInsets.only(left: 4.0, right: 4.0, bottom: 6.0, top: 2.0),
              onPressed: () => yesOrNo(false),
            )
          : new Text(""),
    ]);
  }

  // when displaying the list to the user, checks whether or not it will be the search results or regular list
  ListView listOfSongs() {
    // helps wrap the text if the song is too long
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    if (!searching) {
      // the scrollable list DJ's songlist
      return new ListView.builder(
        itemCount: globals.djSonglist.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            shape: Border(bottom: BorderSide(color: Colors.cyan)),
            child: new Container(
              width: cWidth,
              color: Colors.white12,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: new RichText(
                      text: new TextSpan(
                        text: '${globals.djSonglist[index]}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          letterSpacing: 1.0,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  new Icon(Icons.keyboard_arrow_right),
                  new Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                  ),
                  Expanded(
                    child: new RichText(
                      text: new TextSpan(
                        text: '${globals.djArtistlist[index]}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          letterSpacing: 1.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                  ),
                  // selects this particular song and user then enters the queue
                  new RaisedButton(
                    child: new RichText(
                      text: new TextSpan(
                        text: 'Select',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          letterSpacing: 1.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                    color: Colors.cyan,
                    padding: EdgeInsets.only(
                        left: 4.0, right: 4.0, bottom: 6.0, top: 2.0),
                    onPressed: () => selectMe(index),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (searching) {
      // the scrollable list of searched songs
      return new ListView.builder(
        itemCount: globals.userSearchSongs.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            shape: Border(bottom: BorderSide(color: Colors.cyan)),
            child: new Container(
              width: cWidth,
              color: Colors.white,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // displays song title
                  Expanded(
                    child: new RichText(
                      text: new TextSpan(
                        text: '${globals.userSearchSongs[index]}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          letterSpacing: 1.0,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  new Icon(Icons.keyboard_arrow_right),
                  new Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                  ),
                  // displays song artist
                  Expanded(
                    child: new RichText(
                      text: new TextSpan(
                        text: '${globals.userSearchArtists[index]}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          letterSpacing: 1.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                  ),
                  // selects this particular song and user then enters the queue
                  new RaisedButton(
                    child: new RichText(
                      text: new TextSpan(
                        text: 'Select',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          letterSpacing: 1.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                    color: Colors.cyan,
                    padding: EdgeInsets.only(
                        left: 4.0, right: 4.0, bottom: 6.0, top: 2.0),
                    onPressed: () => selectMe(globals.djIndex[index]),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // These were put into variables because they will change when the user begins
  // a search
  Widget appBarTitle = new Text("Select a song");
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    // to help with text wrapping if the song title is too long
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: appBarTitle,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              // this is where the search function will go
              new IconButton(
                icon: actionIcon,
                onPressed: () {
                  setState(() {
                    // if they press this button and it is currently the search button, do search things
                    if (this.actionIcon.icon == Icons.search) {
                      this.actionIcon = new Icon(Icons.close);
                      this.appBarTitle = new TextField(
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                        decoration: new InputDecoration(
                            prefixIcon:
                                new Icon(Icons.search, color: Colors.white),
                            hintText: "Enter Search Here",
                            hintStyle: new TextStyle(color: Colors.white30)),
                        maxLength: 12,
                        onSubmitted: (String findMe) {
                          print(findMe);
                          /* SEAN: We now have the string to search with
                         Variable: findMe

                         We need to search these arrays:
                         Song Array: globals.djSonglist
                         Artist Array: globals.djArtistlist

                         And put them in these arrays:
                         globals.userSearchSongs
                         globals.userSearchArtists
                      */
                          searching = true;
                        },
                      );
                    }
                    // else the icon they have pressed is the exit button, so go back
                    else {
                      this.actionIcon = new Icon(Icons.search);
                      this.appBarTitle = new Text("Select a song");
                      searching = false;
                    }
                  });
                },
              ),
            ]),
        backgroundColor: backColor,
        // displays list of songs and exit button
        body: new Column(
          children: <Widget>[
            new Expanded(child: listOfSongs()),
            exitButton(),
          ],
        ));
  }
}
