import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View
} from 'react-native';
import Maps from './Maps';
import User from './User';
import Record from './Record';
import Library from './Library';
import AudioWrapper from './AudioWrapper';

class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Maps />
        {/* <Record /> */}
        <User />
        <AudioWrapper />
        {/* <Library /> */}
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
