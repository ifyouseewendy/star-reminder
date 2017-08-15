import React, { Component } from "react";
import PropTypes from "prop-types";
import _ from "lodash";
import {
  Button,
  CalloutCard,
  Card,
  DisplayText,
  FormLayout,
  Layout,
  Select,
  Stack,
  TextField,
} from "@shopify/polaris";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = props.digest;
  }

  formChanged() {
    return this.props.digest !== this.state;
  }

  renderIndex() {
    return (
      <Layout>
        <Layout.Section>
          <DisplayText size="Large">{"> Github Star Reminder"}</DisplayText>
        </Layout.Section>
        <Layout.Section>
          <CalloutCard
            illustration="https://assets-cdn.github.com/images/modules/logos_page/Octocat.png"
            primaryAction={{
              content: "Login via Github",
              url: "/auth/github",
            }}
          >
            <p>Get a digest email of your Github stars every week.</p>
          </CalloutCard>
        </Layout.Section>
      </Layout>
    );
  }

  renderDashboard() {
    console.log(this.state);
    return (
      <Layout>
        <Layout.Section>
          <DisplayText size="Large">{"> Github Star Reminder"}</DisplayText>
        </Layout.Section>
        <Layout.Section>
          <Card sectioned>
            <FormLayout>
              <TextField
                label="Email"
                name="email"
                type="email"
                value={this.props.email}
                disabled
              />
              <TextField
                label="Github username"
                name="github-username"
                type="text"
                value={this.props.githubUserName}
                disabled
              />
              <Stack
                alignment="trailing"
                distribution="fill"
              >
                <TextField
                  label="Send email"
                  prefix="at"
                  type="number"
                  min="1"
                  max="12"
                  value={this.state.hour}
                  onChange={v => this.setState({ hour: Number(v) })}
                  connectedRight={
                    <Select
                      label="meridiem"
                      labelHidden
                      options={["am", "pm"]}
                      value={this.state.meridiem}
                      onChange={meridiem => this.setState({ meridiem })}
                    />
                  }
                />
                <Select
                  options={["every week", "every day"]}
                  value={this.state.frequency}
                  onChange={frequency => this.setState({ frequency })}
                />
              </Stack>
              <TextField
                label="Digest count of each email"
                type="number"
                value={this.state.count}
                min="0"
                onChange={count => this.setState({ count: Number(count) })}
              />
              <Button primary url="#" disabled={!this.formChanged()} submit>
                Save
              </Button>
            </FormLayout>
          </Card>
        </Layout.Section>
      </Layout>
    );
  }

  render() {
    if (this.props.email) {
      return this.renderDashboard();
    }
    return this.renderIndex();
  }
}

App.propTypes = {
  email: PropTypes.string.isRequired,
  githubUserName: PropTypes.string.isRequired,
  digest: PropTypes.shape({
    frequency: PropTypes.oneOf(["every week", "every day"]),
    hour: PropTypes.oneOf(_.range(1, 13)),
    meridiem: PropTypes.oneOf(["am", "pm"]),
    count: PropTypes.number.isRequired,
  }).isRequired,
};

export default App;
