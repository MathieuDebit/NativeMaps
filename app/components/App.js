import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';
import Maps from './Maps';
import User from './User';
import Library from './Library';

class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Maps />
        <User />
        <Library />
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
  },
});

export default App;
