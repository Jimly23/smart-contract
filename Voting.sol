// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.2 <0.9.0;

contract VotingApp {
    struct Voting {
        address owner;
        string name;
        address[] voters;
        uint256 voting;
    }

    mapping(uint256 => Voting) public candidates;
    mapping(address => bool) public listVoters;
    mapping(address => bool) public existingOwner;
    mapping(bytes32 => bool) public existingName;

    uint256 public numberOfCandidates = 0;

    event Voted(address indexed voter, uint256 candidateId);


    
    function addCandidate(address _owner, string memory _name) public {
        require(_owner != address(0), "Invalid address");
        require(bytes(_name).length > 0, "Name don't have empty"); // bytes("Jimlee") = [0x4a, 0x69, 0x6d, 0x6c, 0x65, 0x65]

        // Validation existing candidate
        require(!existingOwner[_owner], "Owner was added!");
        require(!existingName[keccak256(bytes(_name))], "Name was added!");

        // Save new candidate
        Voting storage candidate = candidates[numberOfCandidates];
        candidate.owner = _owner;
        candidate.name = _name;

        // Update existingOwner & wxistingName mapping
        existingOwner[_owner] = true;
        existingName[keccak256(bytes(_name))] = true;


        numberOfCandidates++;
    }
    
    function voteCandidate(uint256 _id) public {
        require(numberOfCandidates > _id, "Invalid ID");
        require(!listVoters[msg.sender], "This address has already voted before");

        Voting storage candidate = candidates[_id];

        listVoters[msg.sender] = true;
        candidate.voters.push(msg.sender);
        candidate.voting++;
    }
    
    function getCandidateById(uint256 _id) public view  returns (Voting memory) {
        require(numberOfCandidates > _id, "Invalid Id");

        Voting memory data = Voting({
            owner: candidates[_id].owner,
            name: candidates[_id].name,
            voting: candidates[_id].voting,
            voters: candidates[_id].voters
        });

        return data;
    }
    
    function getAllCandidate() public view returns (address[] memory _owners, string[] memory _names, uint256[] memory _votings) {
        _owners = new address[](numberOfCandidates);
        _names = new string[](numberOfCandidates);
        _votings = new uint256[](numberOfCandidates);

        for (uint i=0; i<numberOfCandidates; i++) 
        {
            Voting memory item = candidates[i];
            _owners[i] = item.owner;
            _names[i] = item.name;
            _votings[i] = item.voting;
        }

        return (_owners, _names, _votings);
    }

}