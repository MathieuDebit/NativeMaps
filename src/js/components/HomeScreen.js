import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  Button,
  TouchableHighlight,
  View
} from 'react-native';
import Maps from './Maps';
import User from './User';
import Record from './Record';
import Library from './Library';
import AudioWrapper from './AudioWrapper';

export default class HomeScreen extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text>Artiste de la semaine</Text>

        <TouchableHighlight
          style={styles.button}
          onPress={this.props.startMap}
        >
          <Text style={styles.buttonText}>Commencer</Text>
        </TouchableHighlight>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
  },
  button: {
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 30,
    width: 200,
    height: 50,
    borderRadius: 50,
    backgroundColor: "#FFFFFF",
    borderColor: "#0099FF",
    borderWidth: 3,
    shadowColor: "#000000",
    shadowOpacity: 0.16,
    shadowRadius: 3,
    shadowOffset: {
      height: 3,
      width: 0
    }
  },
  buttonText: {
    color: "#0099FF",
    fontSize: 17,
  }
});
